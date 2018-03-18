/*!
 * \file dragoncopy.c
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2017
 * \license MIT
 */

#include <linux/kernel.h>
#include <linux/syscalls.h>
#include <linux/fs.h>
#include <asm/segment.h>
#include <asm/uaccess.h>

asmlinkage long sys_dragoncopy (const char *src, const char *dst) {
    struct file *srcp;
    struct file *dstp;
    loff_t read_pos = 0, write_pos = 0;
    int num = 0;
    char buf[50];

    mm_segment_t old_fs = get_fs();
    set_fs(KERNEL_DS);

    srcp = filp_open(src, O_CREAT | O_RDWR, S_IRWXU | S_IRWXG | S_IRWXO);
    if (IS_ERR(srcp)) {
        printk("Dragon copy open file failed.\n");
        return -1;
    }

    dstp = filp_open(dst, O_CREAT | O_RDWR, S_IRWXU | S_IRWXG | S_IRWXO);

    num = vfs_read(srcp, buf, 40, &read_pos);
    while (num != 0) {
        vfs_write(dstp, buf, num, &write_pos);
        num = vfs_read(srcp, buf, 40, &read_pos);
    }

    filp_close(srcp, 0);
    filp_close(dstp, 0);

    set_fs(old_fs);

    return 0;
}

