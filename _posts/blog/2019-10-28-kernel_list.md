---
layout:     post
title:      "Kernel list"
date:       2019-10-28 17:18:00
author:     권 진영 (gc757489@gmail.com)
categories: blog
tags:       kernel, list, 
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

그림을 보시면 list_replace 함수와 다르게 old가 초기화되어 자기 자신을 가가리킵니다.

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

```C
/**
 * list_move - delete from one list and add as another's head
 * @list: the entry to move
 * @head: the head that will precede our entry
 */
static inline void list_move(struct list_head *list, struct list_head *head) //list 제거 후 head의 뒤에 추가
{
	__list_del_entry(list);
	list_add(list, head);
}

/**
 * list_move_tail - delete from one list and add as another's tail
 * @list: the entry to move
 * @head: the head that will follow our entry
 */
static inline void list_move_tail(struct list_head *list, //list 제거 후 head의 앞에 추가
				  struct list_head *head)
{
	__list_del_entry(list);
	list_add_tail(list, head);
}

/**
 * list_bulk_move_tail - move a subsection of a list to its tail
 * @head: the head that will follow our entry
 * @first: first entry to move
 * @last: last entry to move, can be the same as first
 *
 * Move all entries between @first and including @last before @head.
 * All three entries must belong to the same linked list.
 */
static inline void list_bulk_move_tail(struct list_head *head, //first~last를 head의 앞부분에 넣음
				       struct list_head *first,
				       struct list_head *last)
{
	first->prev->next = last->next;
	last->next->prev = first->prev;

	head->prev->next = first;
	first->prev = head->prev;

	last->next = head;
	head->prev = last;
}
```
```C
/**
 * list_is_first -- tests whether @list is the first entry in list @head
 * @list: the entry to test
 * @head: the head of the list
 */
static inline int list_is_first(const struct list_head *list, //list가 처음인지 확인//inline함수라 함수호출부분에 대입하면된다
					const struct list_head *head)
{
	return list->prev == head;
}

/**
 * list_is_last - tests whether @list is the last entry in list @head
 * @list: the entry to test
 * @head: the head of the list
 */
static inline int list_is_last(const struct list_head *list, //list가 마지막인지 확인
				const struct list_head *head)
{
	return list->next == head;
}

/**
 * list_empty - tests whether a list is empty
 * @head: the list to test.
 */
static inline int list_empty(const struct list_head *head) // 리스트가 비어있는지 확인
{
	return READ_ONCE(head->next) == head; 
    /*
    #define __READ_ONCE(x, check)                       \
        ({                                  \
         union { typeof(x) __val; char __c[1]; } __u;            \
         if (check)                          \
         __read_once_size(&(x), __u.__c, sizeof(x));     \
         else                                \
         __read_once_size_nocheck(&(x), __u.__c, sizeof(x)); \
         __u.__val;                          \
         })
    #define READ_ONCE(x) __READ_ONCE(x, 1)
     */
}

/**
 * list_empty_careful - tests whether a list is empty and not being modified
 * @head: the list to test
 *
 * Description:
 * tests whether a list is empty _and_ checks that no other CPU might be
 * in the process of modifying either member (next or prev)
 *
 * NOTE: using list_empty_careful() without synchronization
 * can only be safe if the only activity that can happen
 * to the list entry is list_del_init(). Eg. it cannot be used
 * if another CPU could re-list_add() it.
 */
static inline int list_empty_careful(const struct list_head *head)
{
	struct list_head *next = head->next;
	return (next == head) && (next == head->prev);
}

/**
 * list_rotate_left - rotate the list to the left
 * @head: the head of the list
 */
static inline void list_rotate_left(struct list_head *head) //head의 next를 head의 앞에 추가 //그림그리면서 다시 확인하기
{
	struct list_head *first;

	if (!list_empty(head)) {
		first = head->next;
		list_move_tail(first, head);
	}
}

/**
 * list_rotate_to_front() - Rotate list to specific item.
 * @list: The desired new front of the list.
 * @head: The head of the list.
 *
 * Rotates list so that @list becomes the new front of the list.
 */
static inline void list_rotate_to_front(struct list_head *list,
					struct list_head *head)
{
	/*
	 * Deletes the list head from the list denoted by @head and
	 * places it as the tail of @list, this effectively rotates the
	 * list so that @list is at the front.
	 */
	list_move_tail(head, list);
}

/**
 * list_is_singular - tests whether a list has just one entry.
 * @head: the list to test.
 */
static inline int list_is_singular(const struct list_head *head)
{
	return !list_empty(head) && (head->next == head->prev);
}

static inline void __list_cut_position(struct list_head *list, 
		struct list_head *head, struct list_head *entry)
{
	struct list_head *new_first = entry->next;
	list->next = head->next;
	list->next->prev = list;
	list->prev = entry;
	entry->next = list;
	head->next = new_first;
	new_first->prev = head;
}

/**
 * list_cut_position - cut a list into two
 * @list: a new list to add all removed entries
 * @head: a list with entries
 * @entry: an entry within head, could be the head itself
 *	and if so we won't cut the list
 *
 * This helper moves the initial part of @head, up to and
 * including @entry, from @head to @list. You should
 * pass on @entry an element you know is on @head. @list
 * should be an empty list or a list you do not care about
 * losing its data.
 *
 */
static inline void list_cut_position(struct list_head *list,
		struct list_head *head, struct list_head *entry)
{
	if (list_empty(head))
		return;
	if (list_is_singular(head) &&
		(head->next != entry && head != entry))
		return;
	if (entry == head)
		INIT_LIST_HEAD(list);
	else
		__list_cut_position(list, head, entry);
}

/**
 * list_cut_before - cut a list into two, before given entry
 * @list: a new list to add all removed entries
 * @head: a list with entries
 * @entry: an entry within head, could be the head itself
 *
 * This helper moves the initial part of @head, up to but
 * excluding @entry, from @head to @list.  You should pass
 * in @entry an element you know is on @head.  @list should
 * be an empty list or a list you do not care about losing
 * its data.
 * If @entry == @head, all entries on @head are moved to
 * @list.
 */
static inline void list_cut_before(struct list_head *list,
				   struct list_head *head,
				   struct list_head *entry)
{
	if (head->next == entry) {
		INIT_LIST_HEAD(list);
		return;
	}
	list->next = head->next;
	list->next->prev = list;
	list->prev = entry->prev;
	list->prev->next = list;
	head->next = entry;
	entry->prev = head;
}

static inline void __list_splice(const struct list_head *list,
				 struct list_head *prev,
				 struct list_head *next)
{
	struct list_head *first = list->next;
	struct list_head *last = list->prev;

	first->prev = prev;
	prev->next = first;

	last->next = next;
	next->prev = last;
}

/**
 * list_splice - join two lists, this is designed for stacks
 * @list: the new list to add.
 * @head: the place to add it in the first list.
 */
static inline void list_splice(const struct list_head *list,
				struct list_head *head)
{
	if (!list_empty(list))
		__list_splice(list, head, head->next);
}

/**
 * list_splice_tail - join two lists, each list being a queue
 * @list: the new list to add.
 * @head: the place to add it in the first list.
 */
static inline void list_splice_tail(struct list_head *list,
				struct list_head *head)
{
	if (!list_empty(list))
		__list_splice(list, head->prev, head);
}

/**
 * list_splice_init - join two lists and reinitialise the emptied list.
 * @list: the new list to add.
 * @head: the place to add it in the first list.
 *
 * The list at @list is reinitialised
 */
static inline void list_splice_init(struct list_head *list,
				    struct list_head *head)
{
	if (!list_empty(list)) {
		__list_splice(list, head, head->next);
		INIT_LIST_HEAD(list);
	}
}

/**
 * list_splice_tail_init - join two lists and reinitialise the emptied list
 * @list: the new list to add.
 * @head: the place to add it in the first list.
 *
 * Each of the lists is a queue.
 * The list at @list is reinitialised
 */
static inline void list_splice_tail_init(struct list_head *list,
					 struct list_head *head)
{
	if (!list_empty(list)) {
		__list_splice(list, head->prev, head);
		INIT_LIST_HEAD(list);
	}
}
```

```C
/**
 * list_entry - get the struct for this entry
 * @ptr:	the &struct list_head pointer.
 * @type:	the type of the struct this is embedded in.
 * @member:	the name of the list_head within the struct.
 */
#define list_entry(ptr, type, member) \
	container_of(ptr, type, member)

/**
 * list_first_entry - get the first element from a list
 * @ptr:	the list head to take the element from.
 * @type:	the type of the struct this is embedded in.
 * @member:	the name of the list_head within the struct.
 *
 * Note, that list is expected to be not empty.
 */
#define list_first_entry(ptr, type, member) \
	list_entry((ptr)->next, type, member)

/**
 * list_last_entry - get the last element from a list
 * @ptr:	the list head to take the element from.
 * @type:	the type of the struct this is embedded in.
 * @member:	the name of the list_head within the struct.
 *
 * Note, that list is expected to be not empty.
 */
#define list_last_entry(ptr, type, member) \
	list_entry((ptr)->prev, type, member)

/**
 * list_first_entry_or_null - get the first element from a list
 * @ptr:	the list head to take the element from.
 * @type:	the type of the struct this is embedded in.
 * @member:	the name of the list_head within the struct.
 * Note that if the list is empty, it returns NULL.
 */
#define list_first_entry_or_null(ptr, type, member) ({ \
	struct list_head *head__ = (ptr); \
	struct list_head *pos__ = READ_ONCE(head__->next); \
	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
})

/**
 * list_next_entry - get the next element in list
 * @pos:	the type * to cursor
 * @member:	the name of the list_head within the struct.
 */
#define list_next_entry(pos, member) \
	list_entry((pos)->member.next, typeof(*(pos)), member)

/**
 * list_prev_entry - get the prev element in list
 * @pos:	the type * to cursor
 * @member:	the name of the list_head within the struct.
 */
#define list_prev_entry(pos, member) \
	list_entry((pos)->member.prev, typeof(*(pos)), member)

/**
 * list_for_each	-	iterate over a list
 * @pos:	the &struct list_head to use as a loop cursor.
 * @head:	the head for your list.
 */
#define list_for_each(pos, head) \
	for (pos = (head)->next; pos != (head); pos = pos->next)

/**
 * list_for_each_prev	-	iterate over a list backwards
 * @pos:	the &struct list_head to use as a loop cursor.
 * @head:	the head for your list.
 */
#define list_for_each_prev(pos, head) \
	for (pos = (head)->prev; pos != (head); pos = pos->prev)

/**
 * list_for_each_safe - iterate over a list safe against removal of list entry
 * @pos:	the &struct list_head to use as a loop cursor.
 * @n:		another &struct list_head to use as temporary storage
 * @head:	the head for your list.
 */
#define list_for_each_safe(pos, n, head) \
	for (pos = (head)->next, n = pos->next; pos != (head); \
		pos = n, n = pos->next)

/**
 * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
 * @pos:	the &struct list_head to use as a loop cursor.
 * @n:		another &struct list_head to use as temporary storage
 * @head:	the head for your list.
 */
#define list_for_each_prev_safe(pos, n, head) \
	for (pos = (head)->prev, n = pos->prev; \
	     pos != (head); \
	     pos = n, n = pos->prev)

/**
 * list_for_each_entry	-	iterate over list of given type
 * @pos:	the type * to use as a loop cursor.
 * @head:	the head for your list.
 * @member:	the name of the list_head within the struct.
 */
#define list_for_each_entry(pos, head, member)				\
	for (pos = list_first_entry(head, typeof(*pos), member);	\
	     &pos->member != (head);					\
	     pos = list_next_entry(pos, member))

/**
 * list_for_each_entry_reverse - iterate backwards over list of given type.
 * @pos:	the type * to use as a loop cursor.
 * @head:	the head for your list.
 * @member:	the name of the list_head within the struct.
 */
#define list_for_each_entry_reverse(pos, head, member)			\
	for (pos = list_last_entry(head, typeof(*pos), member);		\
	     &pos->member != (head); 					\
	     pos = list_prev_entry(pos, member))

/**
 * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue()
 * @pos:	the type * to use as a start point
 * @head:	the head of the list
 * @member:	the name of the list_head within the struct.
 *
 * Prepares a pos entry for use as a start point in list_for_each_entry_continue().
 */
#define list_prepare_entry(pos, head, member) \
	((pos) ? : list_entry(head, typeof(*pos), member))

/**
 * list_for_each_entry_continue - continue iteration over list of given type
 * @pos:	the type * to use as a loop cursor.
 * @head:	the head for your list.
 * @member:	the name of the list_head within the struct.
 *
 * Continue to iterate over list of given type, continuing after
 * the current position.
 */
#define list_for_each_entry_continue(pos, head, member) 		\
	for (pos = list_next_entry(pos, member);			\
	     &pos->member != (head);					\
	     pos = list_next_entry(pos, member))

/**
 * list_for_each_entry_continue_reverse - iterate backwards from the given point
 * @pos:	the type * to use as a loop cursor.
 * @head:	the head for your list.
 * @member:	the name of the list_head within the struct.
 *
 * Start to iterate over list of given type backwards, continuing after
 * the current position.
 */
#define list_for_each_entry_continue_reverse(pos, head, member)		\
	for (pos = list_prev_entry(pos, member);			\
	     &pos->member != (head);					\
	     pos = list_prev_entry(pos, member))

/**
 * list_for_each_entry_from - iterate over list of given type from the current point
 * @pos:	the type * to use as a loop cursor.
 * @head:	the head for your list.
 * @member:	the name of the list_head within the struct.
 *
 * Iterate over list of given type, continuing from current position.
 */
#define list_for_each_entry_from(pos, head, member) 			\
	for (; &pos->member != (head);					\
	     pos = list_next_entry(pos, member))

/**
 * list_for_each_entry_from_reverse - iterate backwards over list of given type
 *                                    from the current point
 * @pos:	the type * to use as a loop cursor.
 * @head:	the head for your list.
 * @member:	the name of the list_head within the struct.
 *
 * Iterate backwards over list of given type, continuing from current position.
 */
#define list_for_each_entry_from_reverse(pos, head, member)		\
	for (; &pos->member != (head);					\
	     pos = list_prev_entry(pos, member))

/**
 * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
 * @pos:	the type * to use as a loop cursor.
 * @n:		another type * to use as temporary storage
 * @head:	the head for your list.
 * @member:	the name of the list_head within the struct.
 */
#define list_for_each_entry_safe(pos, n, head, member)			\
	for (pos = list_first_entry(head, typeof(*pos), member),	\
		n = list_next_entry(pos, member);			\
	     &pos->member != (head); 					\
	     pos = n, n = list_next_entry(n, member))

/**
 * list_for_each_entry_safe_continue - continue list iteration safe against removal
 * @pos:	the type * to use as a loop cursor.
 * @n:		another type * to use as temporary storage
 * @head:	the head for your list.
 * @member:	the name of the list_head within the struct.
 *
 * Iterate over list of given type, continuing after current point,
 * safe against removal of list entry.
 */
#define list_for_each_entry_safe_continue(pos, n, head, member) 		\
	for (pos = list_next_entry(pos, member), 				\
		n = list_next_entry(pos, member);				\
	     &pos->member != (head);						\
	     pos = n, n = list_next_entry(n, member))

/**
 * list_for_each_entry_safe_from - iterate over list from current point safe against removal
 * @pos:	the type * to use as a loop cursor.
 * @n:		another type * to use as temporary storage
 * @head:	the head for your list.
 * @member:	the name of the list_head within the struct.
 *
 * Iterate over list of given type from current point, safe against
 * removal of list entry.
 */
#define list_for_each_entry_safe_from(pos, n, head, member) 			\
	for (n = list_next_entry(pos, member);					\
	     &pos->member != (head);						\
	     pos = n, n = list_next_entry(n, member))

/**
 * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
 * @pos:	the type * to use as a loop cursor.
 * @n:		another type * to use as temporary storage
 * @head:	the head for your list.
 * @member:	the name of the list_head within the struct.
 *
 * Iterate backwards over list of given type, safe against removal
 * of list entry.
 */
#define list_for_each_entry_safe_reverse(pos, n, head, member)		\
	for (pos = list_last_entry(head, typeof(*pos), member),		\
		n = list_prev_entry(pos, member);			\
	     &pos->member != (head); 					\
	     pos = n, n = list_prev_entry(n, member))

/**
 * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
 * @pos:	the loop cursor used in the list_for_each_entry_safe loop
 * @n:		temporary storage used in list_for_each_entry_safe
 * @member:	the name of the list_head within the struct.
 *
 * list_safe_reset_next is not safe to use in general if the list may be
 * modified concurrently (eg. the lock is dropped in the loop body). An
 * exception to this is if the cursor element (pos) is pinned in the list,
 * and list_safe_reset_next is called after re-taking the lock and before
 * completing the current iteration of the loop body.
 */
#define list_safe_reset_next(pos, n, member)				\
	n = list_next_entry(pos, member)

/*
 * Double linked lists with a single pointer list head.
 * Mostly useful for hash tables where the two pointer list head is
 * too wasteful.
 * You lose the ability to access the tail in O(1).
 */
```
























