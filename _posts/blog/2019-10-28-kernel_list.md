---
layout:     post
title:      "Kernel list"
date:       2019-10-28 17:18:00
author:     권 진영 (gc757489@gmail.com)
categories: blog
tags:       kernel, list
cover:      "/assets/kernel_list/basic.png"
---

```C
/* SPDX-License-Identifier: GPL-2.0 */
#ifndef _LINUX_LIST_H            //#ifndef ~ #endif : 매크로 중복정의를 피하기 위한 매크로
#define _LINUX_LIST_H

#include <linux/types.h>
#include <linux/stddef.h>
#include <linux/poison.h>
#include <linux/const.h>
#include <linux/kernel.h>
```

SPDX(Software Package Data Exchange)는 소프트웨어 BOM 정보(구성 요소, 라이센스, 저작권 및 보안 참조 포함)을 전달하기 위한 공개 표준입니다.


```C
#define LIST_HEAD_INIT(name) { &(name), &(name) } 

#define LIST_HEAD(name) \
	struct list_head name = LIST_HEAD_INIT(name) 

static inline void INIT_LIST_HEAD(struct list_head *list)
{
	WRITE_ONCE(list->next, list);  
	list->prev = list;
}

```

1. LIST_HEAD_INIT(name) { &(name), &(name) } //함수형 매크로 ex. PRINT_NUM(x) printf("%d", x)
1. #define LIST_HEAD(name) struct list_head name = LIST_HEAD_INIT(name) // struct list_head name = {&(name), &(name)} //name 이라는 변수를 만들고 할당
1. WRITE_ONCE의 정의 : //WRITE_ONCE(x, val)  x=(val) // list->next = (list)
1. 초기화 함수이기 때문에 list->next == list->prev == list 입니다.

INIT_LIST_HEAD는 노드를 초기화하는 함수로써 해당 함수의 그림은 아래와 같습니다.

![Alt text](/assets/kernel_list/INIT_LIST_HEAD.png){: width="350"}

```C

#ifdef CONFIG_DEBUG_LIST
extern bool __list_add_valid(struct list_head *new,
			      struct list_head *prev,
			      struct list_head *next);
extern bool __list_del_entry_valid(struct list_head *entry);
#else
static inline bool __list_add_valid(struct list_head *new,
				struct list_head *prev,
				struct list_head *next)
{
	return true;
}
static inline bool __list_del_entry_valid(struct list_head *entry)
{
	return true;
}
#endif



/*
bool __list_add_valid(struct list_head *new, struct list_head *prev,
        struct list_head *next)
{
    if (CHECK_DATA_CORRUPTION(next->prev != prev, //CHECK_DATA_CORRUPTION 데이터 변질 체크
                "list_add corruption. next->prev should be prev (%px), but was %px. (next=%px).\n",
                prev, next->prev, next) ||
            CHECK_DATA_CORRUPTION(prev->next != next,
                "list_add corruption. prev->next should be next (%px), but was %px. (prev=%px).\n",
                next, prev->next, prev) ||
            CHECK_DATA_CORRUPTION(new == prev || new == next,
                "list_add double add: new=%px, prev=%px, next=%px.\n",
                new, prev, next))
        return false;

    return true;
}
*/

```
- extern 외부 변수
 함수 밖의 전역 범위에 선언되며, 프로그램 전체에서 유효하고 다른 파일에서도 참조 가능
 초기화를 생략하면 0으로 자동초기화
 정적 데이터영역에 할당
 extern 변수는 편리하지만 남용하면 프로그램을 복잡하게 하고 나중에 유지보수가 힘듬

- CONFIG_DEBUG_LIST가 선언 되어있으면 외부의 __list_add_valid 및 __list_del_entry_valid를 호출하고 없을경우
 true를 반환하는 함수로 생성합니다.

- bool __list_add_valid함수의 주석처리된 부분은 /lib/list_debug.c 에서 복사해온 부분입니다.
- bool __list_del_entry_valid 도 /lib/list_debug.c에서 확인가능합니다. 

```C
static inline void __list_add(struct list_head *new,
			      struct list_head *prev,
			      struct list_head *next)
{
	if (!__list_add_valid(new, prev, next))
		return;

	next->prev = new;
	new->next = next;
	new->prev = prev;
	WRITE_ONCE(prev->next, new);
}
```
__list_add 함수는 list에 새로운 노드를 추가하는 함수입니다.

![Alt text](/assets/kernel_list/basic.png){: width="700"}

연결리스트는 기본적으로 위와 같이 연결되어 있습니다.

![Alt text](/assets/kernel_list/list_add2.png){: width="700"}

상단의 베이직 그림을 기준으로 entry를 1번 노드 entry->next를 2번 노드라고 할때
1. next->prev = new : 2번 노드의 prev를 새로운 노드로 연결합니다
1. new->next = next : 새로운 노드의 next를 2번 노드로 연결합니다. 
1. new->prev = prev : 새로운 노드의 prev를 1번 노드로 연결합니다. 
1. WRITE_ONCE(prev->next, new) : WRITE_ONCE가WRITE_ONCE(x, val)  x=(val) 이기 때문에
                                 prev->next = (new)가 되어서 1번 노드의 next를 새로운 노드로 연결합니다.
WRITE_ONCE를 사용하는 이유는 컴파일과정 중에서 메모리 최적화가 되는 것을 방지하기 위해 사용합니다.

```C
static inline void list_add(struct list_head *new, struct list_head *head)
{
	__list_add(new, head, head->next);
}
```
list_add는 단순히 __list_add를 호출하는 함수입니다.
__list_add를 호출하여 head의 뒷부분에 추가하도록 하는 함수입니다.

![Alt text](/assets/kernel_list/list_add.png){: width="700"}

```C
static inline void list_add_tail(struct list_head *new, struct list_head *head)
{
	__list_add(new, head->prev, head);
}
```
list_add_tail은 list_add tail과 거의 유사합니다.
다만 차이점은 list_add는 head의 뒷부분에 추가한다면 list_add_tail은 head의 앞에 추가하는 함수입니다.

![Alt text](/assets/kernel_list/list_add_tail.png){: width="700"}

```C
static inline void __list_del(struct list_head * prev, struct list_head * next) //제거하는 함수
{
	next->prev = prev;
	WRITE_ONCE(prev->next, next);
}
```

__list_del은 노드를 삭제하는 함수입니다.

![Alt text](/assets/kernel_list/list_del2.png){: width="700"}

1. next->prev = prev : 삭제하려는 노드의 다음 노드에서 prev를 삭제하려는 노드의 prev노드로 설정하여 삭제하려는 노드와의 연결을 끊습니다.
1. WRITE_ONCE(prev->next, next); : 삭제하려는 노드의 이전 노드에서 next를 삭제하려는 노드의 next노드로 설정하여 삭제하려는 노드와의 연결을 끊습니다.
- 다만 list_del의 경우 삭제하려는 노드에서 next와 prev는 여전히 연결되어있습니다.

```C
static inline void __list_del_clearprev(struct list_head *entry)
{
	__list_del(entry->prev, entry->next);
	entry->prev = NULL;
}
```

__list_del_celarprev 함수는 __list_del함수를 이용하여 삭제하려는 노드의 prev,next 노드를 서로 연결한 이후에 삭제하려는 노드의 prev를 null로 만듭니다.

![Alt text](/assets/kernel_list/list_del_clearprev2.png){: width="700"}


```C
static inline void __list_del_entry(struct list_head *entry) //entry만 삭제
{
	if (!__list_del_entry_valid(entry))
		return;

	__list_del(entry->prev, entry->next);
}
```

__list_del_entry함수는 단순히 __list_del함수를 이용하여 entry노드를 삭제합니다.

```C
static inline void list_del(struct list_head *entry)
{
	__list_del_entry(entry);
	entry->next = LIST_POISON1;  
	entry->prev = LIST_POISON2;
}
```

list_del 함수는 __list_del_entry 함수를 이용하여entry노드를 제거합니다.
이후 entry노드의 prev, next 노드를 LIST_POISON2와1로 설정합니다.

![Alt text](/assets/kernel_list/list_del.png){: width="700"}

LIST_POISON은/include/linux/posion.h에 정의되어있습니다.
LIST_POISON의 정의는 아래 코드와 같이 되어있습니다.

```C
    /*
     * These are non-NULL pointers that will result in page faults
     * under normal circumstances, used to verify that nobody uses
     * non-initialized list entries.
        #define LIST_POISON1  ((void *) 0x100 + POISON_POINTER_DELTA)
        #define LIST_POISON2  ((void *) 0x200 + POISON_POINTER_DELTA)
     */
    /*
     * Architectures might want to move the poison pointer offset
     * into some well-recognized area such as 0xdead000000000000,
     * that is also not mappable by user-space exploits:
        #ifdef CONFIG_ILLEGAL_POINTER_VALUE
        # define POISON_POINTER_DELTA _AC(CONFIG_ILLEGAL_POINTER_VALUE, UL)
        #else
        # define POISON_POINTER_DELTA 0
        #endif
     */
```
LIST_POISON의 정의를 보면 NULL이 아닌 포인터로 정상적인 상황에서 페이지 오류가 발생하여 초기화되지 않은 목록 항목을 사용하지 않는 사람을 확인하는데 사용한다고 되어있습니다.


```C
static inline void list_replace(struct list_head *old, //대체
				struct list_head *new)
{
	new->next = old->next;
	new->next->prev = new;
	new->prev = old->prev;
	new->prev->next = new;
}
```

list_replace는 new 노드를 old노드의 위치에 삽입하는 함수 입니다.

![Alt text](/assets/kernel_list/list_replace.png){: width="700"}

1. new->next = old->next : new 노드의 next를 old 노드의 next로 연결합니다.
1. new->next->prev = new : next 노드의 prev를 new 노드로 연결합니다.
1. new->prev = old->prev : new 노드의 prev를 old 노드의 prev로 연결합니다.
1. new->prev->next = new : prev 노드의 next를 new 노드로 연결합니다.


```C
static inline void list_replace_init(struct list_head *old,
					struct list_head *new)
{
	list_replace(old, new); //대체 작업
	INIT_LIST_HEAD(old); //old에서  next prev 해제
}
```
list_replace_init 함수는 list_replace를 이용하여 old 노드를 새로운 노드로 교체한 후에
old 노드의 prev, next의 연결을 자기 자신으로 하여 초기화 합니다.

![Alt text](/assets/kernel_list/list_replace_init.png){: width="700"}

그림을 보시면 list_replace 함수와 다르게 old가 초기화되어 자기 자신을 가리킵니다.

```C
/**
static inline void list_swap(struct list_head *entry1, //entry1과 entry2의 위치 변경
			     struct list_head *entry2)
{
	struct list_head *pos = entry2->prev;

	list_del(entry2);
	list_replace(entry1, entry2);
	if (pos == entry1)
		pos = entry2;
	list_add(entry1, pos);
}
```

```C
/**
 * list_del_init - deletes entry from list and reinitialize it.
 * @entry: the element to delete from the list.
 */
static inline void list_del_init(struct list_head *entry) // entry제거 후 초기화
{
	__list_del_entry(entry);
	INIT_LIST_HEAD(entry);
}
```

아래는 hlist에 관한 설명입니다.
hlist는 hash list 입니다.
```C
// hlist_head, hlist_node 선언 include/linux/types.h
struct hlist_head {
        struct hlist_node *first;
};

struct hlist_node {
        struct hlist_node *next, **pprev;
};
```
위 코드는 /incldue/linux/types.h에 선언된 hlist_head, hlist_node 입니다.
hlist_node 에서 *prev가 아니라 **pprev를 사용하는 이유는 아래 코드의 주석부분을 보면 알수 있듯이 메모리를 절약하기 위해 사용됩니다.

![Alt text](/assets/kernel_hlist/hlist_basic_picture.PNG){: width="900"}

위 그림은 hash list의 기본적인 형태가 되는 그림입니다.
왼쪽의 Hlist_head 가 모여서 hashtable이 되는 형태입니다. 

```C
/*
 * Double linked lists with a single pointer list head.
 * Mostly useful for hash tables where the two pointer list head is
 * too wasteful.
 * You lose the ability to access the tail in O(1).
 */

#define HLIST_HEAD_INIT { .first = NULL }
#define HLIST_HEAD(name) struct hlist_head name = {  .first = NULL }
#define INIT_HLIST_HEAD(ptr) ((ptr)->first = NULL)
static inline void INIT_HLIST_NODE(struct hlist_node *h)  //hlist = hash list 
{
	h->next = NULL;
	h->pprev = NULL;
}
```
hlist_node를 초기화합니다.

```C
static inline int hlist_unhashed(const struct hlist_node *h)
{
	return !h->pprev;
}
```
```C
static inline int hlist_empty(const struct hlist_head *h)
{
	return !READ_ONCE(h->first);
}
```
hlist_empty는 READ_ONCE(h->first) 를 수행합니다.
READ_ONCE(h->first)는__READ_ONCE(h->first, 1)을 수햅합니다.
__READ_ONCE(h->first, 1)은 아래와 같이 변경될 수 있습니다.
```C
({
   union { 
         typeof(h->first) __val; 
         char __c[1]; 
         } __u; 
   *(__u64 *)__u.__c= *(volatile __u64 *)&(h->first);
   smp_read_barrier_depends(); /* Enforce dependency ordering from x */   \
   __u.__val;
 })
```
위 코드는 READ_ONCE를 __READ_ONCE와 __READ_ONE_SIZE를 사용하여 보기 쉽게 변환한 것입니다.
공용체로 h->first 와 같은 자료형의 __val을 선언하고
__c[1]을 선언합니다.
__READ_ONCE_SIZE에서 __u.__c는 h=>first의 주소가 타입캐스팅되어 저장됩니다.
__u.__c와 __u.__val은 같은 메모리 공간을 사용하기 때문에 결과적으로
READ_ONCE(h->first)는 메모리 공간에서 volatile을 사용하게 타입캐스팅한 후 반납하는 함수입니다.
결과적으로 !READ_ONCE(h->first)를 사용하여 h->first가 존재하면 거짓을 반환합니다.
존재하지않으면 참을 반환합니다.

```C
static inline void __hlist_del(struct hlist_node *n)
{
	struct hlist_node *next = n->next;
	struct hlist_node **pprev = n->pprev;

	WRITE_ONCE(*pprev, next);
	if (next)
		next->pprev = pprev;
}
```

![Alt text](/assets/kernel_hlist/hlist_del.PNG){: width="900"}

삭제하려는 노드 n의 next와 pprev를 각각 *next와 **pprev에 대입한다
WRITE_ONCE(*pprev, next) 는 pprev의 포인터에 next(주소값)을 대입한다.
next가 존재하면 next의 prev로 pprev를 가르킨다.

hlist구조상 pprev는 prev노드의 next포인터의 주소값을 가리킨다.
그러므로 WRITE_ONCE(*pprev, next)는 pprev->next = next 로 생각할 수 있다.


```C
static inline void hlist_del(struct hlist_node *n)
{
	__hlist_del(n);
	n->next = LIST_POISON1;
	n->pprev = LIST_POISON2;
}
```
__hlist_del을 이용하여 n 노드를 삭제 후 n 노드의 next와 pprev를 LIST_POISON으로 연결한다
```C
static inline void hlist_del_init(struct hlist_node *n)
{
	if (!hlist_unhashed(n)) {
		__hlist_del(n);
		INIT_HLIST_NODE(n);
	}
}
```
__helist_del을 이용하여 n 노드를 삭제 후 n노드를 초기화 한다.

```C
static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
{
	struct hlist_node *first = h->first;
	n->next = first;
	if (first)
		first->pprev = &n->next;
	WRITE_ONCE(h->first, n);
	n->pprev = &h->first;
}
```

![Alt text](/assets/kernel_hlist/hlist_add_head.PNG){: width="900"}

간단하게는 first위치에 n 노드를 추가하는 함수입니다.
현재의 head를 받아와서 first를 대입합니다.
n노드의 next를 first로 연결하고
first->pprev를 n의next노드로 연결 
WRITE_ONCE(h->first, n) : h->first=n
n->pprev = &h->first 

```C
/* next must be != NULL */
static inline void hlist_add_before(struct hlist_node *n,
					struct hlist_node *next)
{
	n->pprev = next->pprev;
	n->next = next;
	next->pprev = &n->next;
	WRITE_ONCE(*(n->pprev), n);
}
```
n노드를 next노드의 앞에 추가하는 함수입니다.
n->pprev 를 next=>pprev로 연결합니다.
n->next 를 next노드로 연결합니다.
next->pprev = &n->next : next->pprev = &(n->next)으로 생각하면 좀더 이해하기 쉬울것 같습니다.
next->pprev 에 n->next의 주소값을 전달합니다.

요거만 잘이해안되넹
n->pprev = next->pprev;   : &next->pprev->next 가 되야는거 아닌가?
WRITE_ONCE(*(n->pprev), n); : n->pprev 가 이전노드인데 이전노드에 포인트라 그게 next를 뜻하는거고 next가 n을 가리키는거면 ok

```C
static inline void hlist_add_behind(struct hlist_node *n,
				    struct hlist_node *prev)
{
	n->next = prev->next;
	prev->next = n;
	n->pprev = &prev->next;

	if (n->next)
		n->next->pprev  = &n->next;
}
```

![Alt text](/assets/kernel_hlist/hlist_add_behind.PNG){: width="900"}

hlist_add_behind 는 특정 노드의 뒷부분에 삽입하는 함수입니다.

```C
/* after that we'll appear to be on some hlist and hlist_del will work */
static inline void hlist_add_fake(struct hlist_node *n)
{
	n->pprev = &n->next;
}
```
hlist에 n이 있는것 처럼 보이게 합니다. 보통 hlist_del을 작동하게 할때 사용합니다.

```C
static inline bool hlist_fake(struct hlist_node *h)
{
	return h->pprev == &h->next;
}
```
```C
/*
 * Check whether the node is the only node of the head without
 * accessing head:
 */
static inline bool
hlist_is_singular_node(struct hlist_node *n, struct hlist_head *h)
{
	return !n->next && n->pprev == &h->first;
}
```

![Alt text](/assets/kernel_hlist/hlist_is_singular_node.PNG){: width="900"}

head에 접근하지 않고 노드가 헤드의 유일한 노드인지 확인
n의 next가 없고 n의 pprev가 head->first의 주소값을 가리키면 유일한 노드임을 알 수 있습니다.
```C
/*
 * Move a list from one list head to another. Fixup the pprev
 * reference of the first entry if it exists.
 */
static inline void hlist_move_list(struct hlist_head *old,
				   struct hlist_head *new)
{
	new->first = old->first;
	if (new->first)
		new->first->pprev = &new->first;
	old->first = NULL;
}
```

![Alt text](/assets/kernel_hlist/hlist_move_list.PNG){: width="900"}

<center>< 권진영의 테스트 ></center>

변화체크용도

1. 새로운 head new의 first를 기존의 head의 first가 가리키던 노드로 연결한다.
2. new->first가 있으면 new->first가 가리키는 노드의 pprev를 new->first 포인터 주소값으로 연결한다.
3. 기존 head의 first를 NULL로 변경한다.

```C
#define hlist_entry(ptr, type, member) container_of(ptr,type,member)

```
```C
/**
 * container_of - cast a member of a structure out to the containing structure
 * @ptr: the pointer to the member.
 * @type:   the type of the container struct this is embedded in.
 * @member:    the name of the member within the struct.
 *
 */
#define container_of(ptr, type, member) ({              \
        void *__mptr = (void *)(ptr);                   \
        BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&   \
                !__same_type(*(ptr), void),            \
                "pointer type mismatch in container_of()");    \
                ((type *)(__mptr - offsetof(type, member))); })

```

```C
#define hlist_for_each(pos, head) \
	for (pos = (head)->first; pos ; pos = pos->next)
```
hlist_for_each 를 해당 hlist 전체를 순회하는 for문으로 변경합니다


```C
#define hlist_for_each_safe(pos, n, head) \
	for (pos = (head)->first; pos && ({ n = pos->next; 1; }); \
	     pos = n)
```
hlist_for_each와 비슷한 매크로입니다.
pos와 n에 pos->next값을 받아서 미리 null 체크를 합니다.

```C
#define hlist_entry_safe(ptr, type, member) \
	({ typeof(ptr) ____ptr = (ptr); \
	   ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
	})
```

```C
/**
 * hlist_for_each_entry	- iterate over list of given type
 * @pos:	the type * to use as a loop cursor.
 * @head:	the head for your list.
 * @member:	the name of the hlist_node within the struct.
 */
#define hlist_for_each_entry(pos, head, member)				\
	for (pos = hlist_entry_safe((head)->first, typeof(*(pos)), member);\
	     pos;							\
	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
```


```C
/**
 * hlist_for_each_entry_continue - iterate over a hlist continuing after current point
 * @pos:	the type * to use as a loop cursor.
 * @member:	the name of the hlist_node within the struct.
 */
#define hlist_for_each_entry_continue(pos, member)			\
	for (pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member);\
	     pos;							\
	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))

/**
 * hlist_for_each_entry_from - iterate over a hlist continuing from current point
 * @pos:	the type * to use as a loop cursor.
 * @member:	the name of the hlist_node within the struct.
 */
#define hlist_for_each_entry_from(pos, member)				\
	for (; pos;							\
	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))

/**
 * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
 * @pos:	the type * to use as a loop cursor.
 * @n:		another &struct hlist_node to use as temporary storage
 * @head:	the head for your list.
 * @member:	the name of the hlist_node within the struct.
 */
#define hlist_for_each_entry_safe(pos, n, head, member) 		\
	for (pos = hlist_entry_safe((head)->first, typeof(*pos), member);\
	     pos && ({ n = pos->member.next; 1; });			\
	     pos = hlist_entry_safe(n, typeof(*pos), member))

#endif
```
