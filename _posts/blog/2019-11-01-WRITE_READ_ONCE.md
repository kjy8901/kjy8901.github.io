---
layout:     post
title:      "Kernel WRITE_ONCE, READ_ONCE"
date:       2019-11-01 17:18:00
author:     권 진영 (gc757489@gmail.com)
categories: blog
tags:       kernel WRITE_ONCE READ_ONCE volatile memorybarrier C
cover:      "/assets/kernel_list/basic.png"
---

####  들어가기전에..

- volatile 변수
변수를 선언할 때volatile 을 사용하면 컴파일러에 해당 변수는 변수의 값을 바꾸는 명려어가 없더라도 그 값이 언제든 변할 수 있다고 알리는 키워드 입니다.
그래서 컴파일러는 해당 변수를 최적화기법 중 하나인 명령어 재배치의 대상에에서 제외하여 항상 메모리에 접근할 수 있도록 변환합니다.
volatile 변수를 사용해야 하는 경우는 최적화에 의해서 오류가 발생할 가능성이 있는 경우 사용하게 되는데 일반적으로
-- 메모리 주소를 가진 I/O 레지스터
-- 인터럽트 핸들러가 값을 변경하는 전역 변수
-- 멀티 스레드 응용 프로그램의 전역 변수
의 경우에 사용해야 합니다.
Java, C# 등의 다른 언어에서 volatile은 다른 스레드에서 visibility를 보장하기 위해 사용된다고 하니 주의가 필요합니다.

- memory barrier
컴파일러에서 명령어 재배치를 통해 순서를 변경하여 최적화 동작을 하는데 명령의 순서를 바꾸면 안되는 경우에 사용하여 특정 연산의 순서를 바꾸지 못하도록 강제하는 기능입니다.
C에서 barrier() 함수는 barrier()이전 코드와 이후 코드가 컴파일러에 의해 순서가 바뀌는 일이 없도록 제한한다.

```C
#define barrier() __asm__ __volatile__("": : :"memory")
```

/include/linux/compier-gcc.h 에 barrier()는 위와 같이 정의되어 있다.
__asm__는 다음에 나오는것이 인라인 어셈블리 임을 나타낸다. 

#### WRITE_ONCE

```C
#define WRITE_ONCE(x, val) \
    ({                          \
     union { typeof(x) __val; char __c[1]; } __u =   \
     { .__val = (__force typeof(x)) (val) }; \
     __write_once_size(&(x), __u.__c, sizeof(x));    \
     __u.__val;                  \
     })
```

```C
#define WRITE_ONCE(x, val) {
     union { 
         typeof(x) __val; 
         char __c[1]; 
     }__u = { .__val = (__force typeof(x)) (val) }; 
     
     __write_once_size(&(x), __u.__c, sizeof(x));    
     __u.__val;                  
}
```
- union 
공용체, 구조체와 공용체의 차이는 메모리를 어떻게 활용하느냐의 차이입니다.
구조체는 멤버 변수마다 각각의 메모리를 할당해주지만, 공용체는 멤버 변수 중 가장 메모리 할당량이 큰 변수 하나의 공간만 할당되어 그 공간을 공유합니다.
- typeof(x)
x의 타입을 반환한다. typeof(x) __val 은 x의 타입(ex. x가 int면 int를 반환)을 반환하여 그 타입으로 __val을 선언한다.
__u = { .__val = (__force typeof(x)) (val) }; 부분은 공용체를 __u로 선언하고 __val에 val을 강제 형변환하여 대입합니다.
```C
static __always_inline void __write_once_size(volatile void *p, void *res, int size)
{
    switch (size) {
        case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
        case 2: *(volatile __u16 *)p = *(__u16 *)res; break;
        case 4: *(volatile __u32 *)p = *(__u32 *)res; break;
        case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
        default:
                barrier();
                __builtin_memcpy((void *)p, (const void *)res, size);
                barrier();
    }
}
```
*p의 경우 &(x)를 받아오고 *res의 경우 __u.__c를 받아옵니다.
&(x)는 x는 결국 list->next 이고 __u.__c는 list가 됩니다.
사실상 같은 크기이기 때문에 __write_once_size함수에서의 역할은 volatile을 사용하기위한 타입캐스팅으로 생각하면 됩니다.

결국 x가 가르키는 것과 val이 가르키는 곳이 같은 메모리 주소이기 때문에 x=val 과 같이 해석할 수 있습니다.

```C
typedef __signed__ char __s8;
typedef unsigned char __u8;

typedef __signed__ short __s16;
typedef unsigned short __u16;

typedef __signed__ int __s32;
typedef unsigned int __u32;

#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
typedef __signed__ long long __s64;
typedef unsigned long long __u64;
#endif
```
__u8,16,32,64는 바로 위 코드와 같이 선언되어 있다.
__write_once_size 함수는 volatile을 사용하여 특정 사이즈를 대상으로는 컴파일 최적화가 일어나지 않도록하고
특정 사이즈가 아닌 경우에는 barrier를 사용하여 연산 순서를 강제하는 함수입니다.

#### READ_ONCE

```C
#define __READ_ONCE(x, check)                                               \
    ({                                                                      \
     union { typeof(x) __val; char __c[1]; } __u;                           \
     if (check)                                                             \
     __read_once_size(&(x), __u.__c, sizeof(x));                            \
     else                                                                   \
     __read_once_size_nocheck(&(x), __u.__c, sizeof(x));                    \
     smp_read_barrier_depends(); /* Enforce dependency ordering from x */   \
     __u.__val;                                                             \
     })
#define READ_ONCE(x) __READ_ONCE(x, 1)
```
READ_ONCE를 호출하면 __READ_ONCE(x,1)을 호출합니다.
__READ_ONCE 에서는 공용체로 __val과 __c를 선언해줍니다.
if (check) 부분에서 check는 READ_ONCE를 통해 호출하는 경우에는 무조건 참이되어
__read_once_size(&(x), __u.__c, sizeof(x))를 호출합니다.

```C
static __always_inline
void __read_once_size(const volatile void *p, void *res, int size)
{
        __READ_ONCE_SIZE;
}
```

```C
static __no_kasan_or_inline
void __read_once_size_nocheck(const volatile void *p, void *res, int size)
{
        __READ_ONCE_SIZE;
}
```
gcc에서 inline 키워드가 강제가 아니다. 하지만 __always_inline을 사용하면 최적화 레벨에 상관없이 함수를 인라인한다.
__no_kasan_or_inline 의 경우에는 아래와 같이 정의되어 있습니다.
```C
#ifdef CONFIG_KASAN
/*
 * We can't declare function 'inline' because __no_sanitize_address confilcts
 * with inlining. Attempt to inline it may cause a build failure.
 *     https://gcc.gnu.org/bugzilla/show_bug.cgi?id=67368
 * '__maybe_unused' allows us to avoid defined-but-not-used warnings.
 */
# define __no_kasan_or_inline __no_sanitize_address notrace __maybe_unused
#else
# define __no_kasan_or_inline __always_inline
#endif
```
__no_sanitize_address가 인라인과 충돌날 수 있기때문에 인라인 선언을 할 수 없습니다.
인라인으로 빌드하면 빌드가 실패할 수 있습니다.
__maybe_unused는 정의되어 있지만 사용하지 않는 경고를 피할수 있도록 합니다.

```C
#define __READ_ONCE_SIZE                                        \
({                                                              \
     switch (size) {                                            \
     case 1: *(__u8 *)res = *(volatile __u8 *)p; break;         \
     case 2: *(__u16 *)res = *(volatile __u16 *)p; break;       \
     case 4: *(__u32 *)res = *(volatile __u32 *)p; break;       \
     case 8: *(__u64 *)res = *(volatile __u64 *)p; break;       \
     default:                                                   \
     barrier();                                                 \
     __builtin_memcpy((void *)res, (const void *)p, size);      \
     barrier();                                                 \
     }                                                          \
})
```

---

### 참고

## volatile
1. https://ko.wikipedia.org/wiki/Volatile_%EB%B3%80%EC%88%98
2. https://dojang.io/mod/page/view.php?id=749
3. https://wodonggun.github.io/wodonggun.github.io/c/c++/%EC%B5%9C%EC%A0%81%ED%99%94%EC%99%80-Volatile-%EB%B3%80%EC%88%98.html
4. https://m.blog.naver.com/PostView.nhn?blogId=eslectures&logNo=80143556699&proxyReferer=https%3A%2F%2Fwww.google.com%2F
5. https://blog.seulgi.kim/2017/11/cpp-volatile.html
6. http://summerlight-textcube.blogspot.com/2009/11/volatile%EA%B3%BC-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EB%B0%B0%EB%A6%AC%EC%96%B4.html

## memory barrier
1. https://ko.wikipedia.org/wiki/%EB%A9%94%EB%AA%A8%EB%A6%AC_%EB%B0%B0%EB%A6%AC%EC%96%B4
2. http://jake.dothome.co.kr/barriers/

## union
1. https://m.blog.naver.com/PostView.nhn?blogId=highkrs&logNo=220186343354&proxyReferer=https%3A%2F%2Fwww.google.com%2F
