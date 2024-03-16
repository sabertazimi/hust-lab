#include <iostream>
#include <string>
#include <cstdlib>

using namespace std;

enum BYTE_TYPE {
	TYPE,
	LENGTH,
	VALUE
};

string parse_bs_msg(string raw_bs_msg) {
	int state =  TYPE;
	int len = static_cast<int>(raw_bs_msg.length());
	string res;

	for (int i = 0; i < len;) {
		switch (state) {
			case TYPE:
			{
				cout << hex << endl;
				cout << dec << endl;
				state = LENGTH;
				break;
			}
			case LENGTH:
				string hex = "0x" + raw_bs_msg.substr(i, 2) + raw_bs_msg.substr(i+3, 2);
				int dec = strtol(hex.c_str(), NULL, 16);
				i += 5;
				state = VALUE;
				break;
			case VALUE:
				break;
			default:
				break;
		}
	}
}

int main(void) {
	cout << parse_bs_msg("00 0a");
	return 0;
}
