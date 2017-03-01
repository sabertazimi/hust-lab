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

// 处理版本问题CONFIG_MODVERSIONS
#if CONFIG_MODVERSIONS == 1
    #define MODVERSIONS
    #include "linux/version.h"
#endif

static int dragondev_open(struct inode *inode, struct file *filp) {
    printk("Dragon device open success.\n");
    return 0;
}

static int dragondev_release (struct inode *inode, struct file *filp) {
    printk("Dragon devicDragon devicease success.\n");
    return 0;
}

static ssize_t dragondev_read (struct file *filp, char __user *target , size_t tsize, loff_t *offset) {
    printk("Dragon device read success.\n");
    return -1;
}

static ssize_t dragondev_write (struct file *filp,const char __user *target , size_t tsize, loff_t *offset) {
    printk("Dragon device write success.\n");
    return -1;
}

static const struct file_operations dragondev_fops = {
    .owner = THIS_MODULE,
    .open = dragondev_open,
    .read = dragondev_read,
    .write = dragondev_write,
    .release = dragondev_release
};

int devnum = 0;

int init_module(void) {
    if ((devnum = register_chrdev(0, "dragondev", &dragondev_fops)) < 0) {
        printk("Dragon device register failed.\n");
    } else {
        printk("Dragon device register success.\n");
    }

    return 0;
}

void cleanup_module(void) {
    unregister_chrdev(devnum, "dragondev");
    printk("Dragon device unregister success.\n");
}

MODULE_AUTHOR("sabertazimi");
MODULE_DESCRIPTION("dragon device");
MODULE_LICENSE("MIT");
MODULE_VERSION("V1.0");

