#include <string>

#define MAXCHILDREN 3

class Tree {

        int maxChildren;
        int childCount;

        Tree * children[MAXCHILDREN];

        Tree * sibling;

        std::string kind;

        int lineno;

        void printSelf(int);
        void printSibling(int);
        void printChildren(int);

        bool addSiblingAux(Tree *, Tree *);

    public:

        int siblingIndex;

        Tree(std::string, int);

        void print(int);
        bool addSibling(Tree *);
        bool addChild(Tree *);

};