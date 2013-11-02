#include <string>

using namespace std;

string tabPrint(int depth) {


    string ret = "";

    if (depth <= 0) {
        return ret;
    }

    while (depth > 1) {

        ret = ret + "|   ";

        depth--;
    }

    return ret + "|   ";

}