---
layout:     post
title:      "Kernel WRITE_ONCE, READ_ONCE"
date:       2019-11-01 17:18:00
author:     권 진영 (gc757489@gmail.com)
categories: blog
tags:       kernel, WRITE_ONCE, READ_ONCE, volatile, memory barrier, C
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

#### READ_ONCE
```C
#define __READ_ONCE(x, check)                       \
    ({                                  \
     union { typeof(x) __val; char __c[1]; } __u;            \
     if (check)                          \
     __read_once_size(&(x), __u.__c, sizeof(x));     \
     else                                \
     __read_once_size_nocheck(&(x), __u.__c, sizeof(x)); \
     smp_read_barrier_depends(); /* Enforce dependency ordering from x */ \
     __u.__val;                          \
     })
#define READ_ONCE(x) __READ_ONCE(x, 1)
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
