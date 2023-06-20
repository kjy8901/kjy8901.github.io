---
layout:     post
title:      "Kernel 개발을 위한 캐릭터디바이스 핸들링"
date:       2019-10-08 14:01:00
author:     권 진영 (gc757489@gmail.com)
categories: blog
tags:       protocol
cover:      ""
---

## Kernel?

커널은 컴퓨터의 운영체제의 핵심이 되는 컴퓨터 프로그램으로 시스템을 완전히 통제한다.
커널의 종류에는 모놀리식 커널, 마이크로 커널, 하이브리드 커널, 엑소 커널이 있다.
#### 모놀리식 커널
하드웨어 위에 고수준의 가상층(프로세스 관리, 동시성, 메모리관리, 시스템 콜)을 가지고 있다.
![Alt text](/assets/monolithic.PNG){: width="900"}
장점
* 커널의 모든 자원에 쉽게 접근 가능하다.
* 서로 자료 구조를 공유한다.
* 시스템 호출 속도가 빠르다.
단점
* 오류 발생시 전체를 검토, 수정해야 하는 불편함이 있다.
* 운영체제 수정시 커널 컴파일을 다시 해야한다.
예시
* BSD, Linux, Solaris, 윈도우NT 등
#### 마이크로 커널
하드웨어 위에 간결한 추상화만 제공, 커널이 제공하는 네트워키 같은 서비스들은 사용자 공간 프로그램인 서버로 구현
![Alt text](/assets/micro.PNG){: width="900"}
장점
* 안정적이다
* 오류 발생시 어떤 부분이 문제인지 쉽게 알 수 있다.
단점
* 메시지 통신으로 이루어져 있어 속도가 느리다.
예시
* AmigaOS, Amoeba, Minix, SpringOS 등
#### 하이브리드 커널
기본적으로 마이크로 커널을 따르지만 느린 코드들을 커널 레벨에서 수행하도록 수정한 커널.
![Alt text](/assets/hybrid.PNG){: width="900"}
예시
* reactOS, Netware 커널 등
#### 엑소 커널

## Character Device, Block Device, Network Device

#### Block Device
디스크와 같이 파일 시스템을 기반으로 일정한 블록 단위로 데이터 읽기/쓰기 수행
Block Device는 하드디스크, 플로피 디스크, 시디 롬과 같이 블럭 단위(섹터)로 데이터를 전송,처리하는 장치다.
#### Character Device
디바이스를 파일처럼 취급하고 접근하여 직접 읽기/쓰기를 수행, 데이터 형태는 스트림방식으로 전송
Character Device는 키보드, 마우스, 사운드 카드 등과 같이 character 단위(byte단위)로 입출력을 하는 장치다.
#### Network Device
네트워크의 물리 계층과 프레임 단위의 데이터를 송수신


## Code

```C
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/sched.h>
#include <linux/syscalls.h>
#include <linux/cdev.h>
#include <linux/slab.h>

#include <asm/uaccess.h>

#define DEV_NAME "virtual_device"
#define DEV_MAJOR 250
#define DEV_MINOR 5

// 장치 드라이버는 고유의 주번호, 부번호 부여가 필요

#define MY_IOC_NUM 100
#define MY_IOC_READ _IOR(MY_IOC_NUM,0,int)          
#define MY_IOC_WRITE _IOW(MY_IOC_NUM,1,int)         
#define MY_IOC_STATUS _IO(MY_IOC_NUM,2)             
#define MY_IOC_READ_WRITE _IOWR(MY_IOC_NUM,3,int)   
#define MY_IOC_NR 4

// IO read, write, data x, r/w
// IOR(int type, int number, data_type)
// type : 장치 드라이버에 고유하게 선택된 8비트 정수, 다른 드라이버와 충돌하지 않도록 선택
// number : 8비트 정수, 드라이버 내에서 고유번호를 선택
// data_type : 클라이언트와 드라이버 간에 교환되는 바이트 수를 계산하는 데 사용되는 데이터 타입

// _IOC_NR() : number 필드 값을 읽는 매크로
// _IOC_TYPE() : type 필드 값을 읽는 매크로
// _IOC_SIZE() : data_type 필드 크기를 읽는 매크로
// _IOC_DIR() : 읽기와 쓰기 속성 필드값을 읽는 매크로

MODULE_LICENSE("GPL"); //모듈이 어떤 라이센스 하에서 커널을 이용하게 되는지 알려주는 역할
MODULE_AUTHOR("KJY"); //모듈 제작자 기재
MODULE_DESCRIPTION("char d test"); //모듈 설명

dev_t dev_num = -1;
struct cdev *virtual_device_cdev = NULL;

static char *buffer = NULL;

int virtual_device_open(struct inode *inode, struct file *filp) {
    printk(KERN_ALERT "virtual_device open function called\n");
    return 0;
}

int virtual_device_release(struct inode *inode, struct file *filp) {
    printk(KERN_ALERT "virtual_device release function called\n");
    return 0;
}

long virtual_device_ioctl(struct file *flip, unsigned int cmd, unsigned long arg) {
    int err = 0, size = 0;

    /*
    if(_IOC_TYPE(cmd) != MY_IOC_NUM)
        return -EINVAL;
    printk(KERN_ALERT "[IOCTL Message]-CMD : %d \n", cmd);
    if(_IOC_NR(cmd) >= MY_IOC_NR)
        return -EINVAL;
    */

    if(_IOC_DIR(cmd) & _IOC_READ) {
        err = access_ok(VERIFY_READ, (void*)arg, sizeof(unsigned long));
        printk(KERN_ALERT "[IOCTL Message]-err : %d \n", err);
        if(err < 0)
            return -EINVAL;
    } else if(_IOC_DIR(cmd) & _IOC_WRITE) {
        err = access_ok(VERIFY_WRITE, (void*)arg, sizeof(unsigned long));
        printk(KERN_ALERT "[IOCTL Message]-err : %d \n", err);
        if(err < 0)
            return -EINVAL;
    } else
        ;
    size = _IOC_SIZE(cmd);
    switch(cmd) {
        case MY_IOC_READ:
            printk(KERN_ALERT "[IOCTL Message]-IOC_READ: \n");
            break;
        case MY_IOC_WRITE:
            printk(KERN_ALERT "[IOCTL Message]-IOC_WRITE: \n");
            break;
        case MY_IOC_STATUS:
            printk(KERN_ALERT "[IOCTL Message]-IOC_STATUS: \n");
            break;
        case MY_IOC_READ_WRITE:
            printk(KERN_ALERT "[IOCTL Message]-IOC_READ_WRITE: \n");
            break;
        default:
            break;
    }
    return 0;
}

ssize_t virtual_device_write(struct file *filp, const char *buf, size_t count, loff_t *f_pos) {
    printk(KERN_ALERT "virtual_device write function called\n");
    return count;
}

ssize_t virtual_device_read(struct file *filp, char *buf, size_t count, loff_t *f_pos) {
    printk(KERN_ALERT "virtual_device read function called\n");
    return count;
}

const struct file_operations vd_fops = {
    .read = virtual_device_read,
    .write = virtual_device_write,
    .open = virtual_device_open,
    .release = virtual_device_release,
    .unlocked_ioctl = virtual_device_ioctl,
};

int __init virtual_device_init(void) {
    dev_num = MKDEV(DEV_MAJOR, DEV_MINOR);
    register_chrdev_region(dev_num, 1, DEV_NAME);
    virtual_device_cdev = cdev_alloc();
    cdev_init(virtual_device_cdev, &vd_fops);
    cdev_add(virtual_device_cdev, dev_num, 1);

    printk(KERN_ALERT "[KERNEL Message]-init : device init and created dev =     [%d]\n", dev_num);
    return 0;
}

void __exit virtual_device_exit(void) {
    unregister_chrdev(250, "virtual_device");
    printk(KERN_ALERT "driver cleanup successful\n");
    kfree(buffer);
}

module_init(virtual_device_init);
module_exit(virtual_device_exit);
```
## Result

- - -
참고
https://www.lazenca.net/pages/viewpage.action?pageId=23789739
http://artoa.hanbat.ac.kr/lecture_data/embedded_sw/04_old.pdf
