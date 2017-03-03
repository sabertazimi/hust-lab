/*!
 * \file inode.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2017
 * \license MIT
 */

#ifndef INODE_H
#define INODE_H

#include <stdint.h>

#define FS_FILE        0x01 ///< file
#define FS_DIRECTORY   0x02 ///< directory
#define FS_CHARDEVICE  0x03 ///< character device
#define FS_BLOCKDEVICE 0x04 ///< block device
#define FS_PIPE        0x05 ///< pipe
#define FS_SYMLINK     0x06 ///< symbol link
#define FS_MOUNTPOINT  0x08 ///< Is the file an active mountpoint?

// file operations interfaces
typedef uint32_t (*read_type_t)(inode*, uint32_t, uint32_t, uint8_t*);
typedef uint32_t (*write_type_t)(inode*, uint32_t, uint32_t, uint8_t*);
typedef void (*open_type_t)(inode*);
typedef void (*close_type_t)(inode*);
typedef dirent* (*readdir_type_t)(inode*, uint32_t);
typedef inode * (*finddir_type_t)(inode*, char *name);

/// \brief file inode
//@TODO mask for user permissons
//@TODO uid/gid for user belongs
//@TODO true_ptr for symbol links or mount points
struct inode {
    char        name[128];      ///< filename
    uint32_t    flags;          ///< node type, refer to above macros
    uint32_t    inode;          ///< inode number, provides a way for a filesystem to identify files
    uint32_t    length;         ///< size of the file(bytes)
    read_type_t read;           ///< read file operation
    write_type_t write;         ///< write file operation
    open_type_t open;           ///< open file operation
    close_type_t close;         ///< close file operation
    readdir_type_t readdir;     ///< read directory file operation
    finddir_type_t finddir;     ///< find directory file operation
};

/// \brief directory entry
struct dirent {
    char name[128]; // filename
    uint32_t ino;     // inode number
};

/// \brief check inode whether is directory or not
bool is_dir(inode *inode);

/// \brief check inode whether is file or not
bool is_file(inode *inode);

/// @TODO operations on inode
/// @TODO imalloc
/// @TODO ifree
/// @TODO iput
/// @TODO iget
/// @TODO imap
/// @TODO idup

// extern inode *fs_root; // root of the filesystem


#endif /* !INODE_H */
