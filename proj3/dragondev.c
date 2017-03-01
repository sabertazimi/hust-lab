/*!
* \file dragondevice.c
* \brief
*
* \author sabertazimi, <sabertazimi@gmail.com>
* \version 1.0
* \date 2017
* \license MIT
*/

#include <linux/fs.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <asm/uaccess.h>

// 处理版本问题CONFIG_MODVERSIONS
#if CONFIG_MODVERSIONS == 1
#define MODVERSIONS
#include "linux/version.h"
#endif

#define BUF_SIZE 1000   ///< buffer size
char buf[BUF_SIZE];     ///< device charaters buffer
int dev_num = 0;        ///< device number
int buf_size = 0;       ///< buffer current size containing characters
int seek_pos = 0;       ///< current 

static int dragondev_open(struct inode *inode, struct file *filp) {
    seek_pos = 0;
    printk("Dragon device open success.\n");
    return 0;
}

static int dragondev_release (struct inode *inode, struct file *filp) {
    seek_pos = 0;
    printk("Dragon device release success.\n");
    return 0;
}

static ssize_t dragondev_read (struct file *filp, char __user *target , size_t tsize, loff_t *offset) {
    size_t read_size = buf_size - seek_pos;
    read_size = read_size < tsize ? read_size : tsize;
    
    if (!copy_to_user((char *)target, buf+seek_pos, read_size)) {
        seek_pos += read_size;
        printk("Dragon device read success.\n");
        return read_size;
    } else {
        printk("Dragon device read failed.\n");
        return -1;
    }
}

static ssize_t dragondev_write (struct file *filp,const char __user *target , size_t tsize, loff_t *offset) {
    size_t write_size = BUF_SIZE - seek_pos;
    write_size = write_size < tsize ? write_size : tsize;
    
    if(!copy_from_user((char *)buf+seek_pos, target, write_size)) {
        seek_pos += write_size;
        buf_size += write_size;
        printk("Dragon device write success.\n");
        return write_size;
    } else {
        printk("Dragon device write failed.\n");
        return -1;
    }
}

static const struct file_operations dragondev_fops = {
    .owner = THIS_MODULE,
    .open = dragondev_open,
    .read = dragondev_read,
    .write = dragondev_write,
    .release = dragondev_release
};


int init_module(void) {
    if ((dev_num = register_chrdev(0, "dragondev", &dragondev_fops)) < 0) {
        printk("Dragon device register failed.\n");
    } else {
        printk("Dragon device register success.\n");
    }
    
    return 0;
}

void cleanup_module(void) {
    unregister_chrdev(dev_num, "dragondev");
    printk("Dragon device unregister success.\n");
}

MODULE_AUTHOR("sabertazimi");
MODULE_DESCRIPTION("dragon device");
MODULE_LICENSE("MIT");
MODULE_VERSION("V1.0");

