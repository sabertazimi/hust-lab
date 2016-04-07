
//////////////////////////////////////////////////////////////////////
//
// @file hex2raw.c - Convert hex numbers to byte code values.
//
// @author Naju Mancheril
//
//////////////////////////////////////////////////////////////////////

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <unistd.h>

unsigned char convert_to_hex_value(char *input);

#define INPUT_STRING_SIZE 4096
#define BYTE_BUFFER_INITIAL_SIZE 1024
#define COMMENT_START "/*"
#define COMMENT_END   "*/"

#define KABOOM_CNT 5

unsigned char* convert_to_byte_string(FILE *file_in, int *size)
{
	int comment_level = 0;
	int  input_string_size = INPUT_STRING_SIZE;
	char input[input_string_size];

  
	int byte_buffer_size = BYTE_BUFFER_INITIAL_SIZE;
	int byte_buffer_offset = 0;

	unsigned char* byte_buffer = (unsigned char*)malloc( BYTE_BUFFER_INITIAL_SIZE * sizeof(*byte_buffer) );
	if ( byte_buffer == NULL )
		{
			return NULL;
		}


	// scan loop
	while ( fscanf(file_in, "%s", input) > 0 )
		{
			// Case 1: Enter a comment block
			if ( !strcmp(input, COMMENT_START) )
				{
					comment_level++;
					continue;
				}

			// Case 2: Leave a comment block
			if ( !strcmp(input, COMMENT_END) )
				{
					if ( comment_level <= 0 )
						{
							// make sure we are in a comment-block
							fprintf(stderr, "Error: stray %s found.\n", COMMENT_END);
							free( byte_buffer );
							return NULL;
						}
					comment_level--;
					continue;
				}

			// Case 3: Convert data to hex value and store
			if ( comment_level == 0 )
				{
					// we should have read a hex value and print it out.
					if ( !isxdigit(input[0]) ||
						 !isxdigit(input[1]) ||
						 (input[2] != '\0') )
						{
							fprintf(stderr,
									"Invalid hex value [%s]. "
									"Please specify only single byte hex values separated by whitespace.\n",
									input);
							free( byte_buffer );
							return NULL;
						}

					unsigned char b = convert_to_hex_value(input);


					// see if we have enough room in the buffer...
					if ( byte_buffer_offset == byte_buffer_size )
						{
							byte_buffer = (unsigned char *)realloc( byte_buffer, 2 * byte_buffer_size );
							if ( byte_buffer == NULL )
								{
									return NULL;
								}
							byte_buffer_size *= 2;
						}
					byte_buffer[ byte_buffer_offset++ ] = b;
				}
		}


	*size = byte_buffer_offset;
	return byte_buffer;
}

void usage(char *name)
{
	printf("usage: %s [-n] [-h]\n", name);
	printf(" -n Nitro mode\n");
	printf(" -h Print this help message\n");
	return;
}

//////////////////////////////////////////////////////////////////////
//
// @fn main
//
//  Read strings from input stream. Each string should be the hex
//  representation of a byte. Write corresponding byte values to
//  output stream.
//
//////////////////////////////////////////////////////////////////////
int main(int argc, char *argv[])
{
	unsigned char* byte_buffer;
	int byte_buffer_size;

	int cnt = 1;
	int i;
	char c;

	while ((c = getopt(argc, argv, "nh")) != -1)
		switch(c)
			{
			case 'h':
				usage(argv[0]);
				return 0;
			case 'n':
				cnt = KABOOM_CNT;
				break;
			default:
				usage(argv[0]);	  
				return -1;
			}


	byte_buffer = convert_to_byte_string(stdin, &byte_buffer_size);
	if ( byte_buffer == NULL )
		return -1;

	for (i = 0; i < cnt; i++)
		{
			char terminator = '\n';
			write(STDOUT_FILENO, byte_buffer, byte_buffer_size);
			write(STDOUT_FILENO, &terminator, 1);
		}


	return 0;
}

//////////////////////////////////////////////////////////////////////
//
// @fn convert_to_hex_value Parses a hex string and returns specified
// byte.
//
// @param input The hex string. Should not have the leading "0x". For
// example, "ab" is a valid value of input, but "0xab" is not.
//
// @return Parsed value.
//
//////////////////////////////////////////////////////////////////////
unsigned char convert_to_hex_value(char *input)
{
	unsigned val;
	sscanf(input, "%x", &val);
	return (unsigned char)val;
}
