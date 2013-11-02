#include <string>
#include <iostream>
#include "util/tabprint.h"
#include "tree.h"

using namespace std;

Tree::Tree(string kind, int line) {

    siblingIndex = 1;
    sibling = NULL;

    for (int i = 0; i < MAXCHILDREN; i++) {
        this->children[i] = NULL;
    }

    maxChildren = MAXCHILDREN;
    childCount = 0;

    this->kind = kind;
    this->lineno = line;
};

void Tree::print(int depth) {
    this->printSelf(depth);
    this->printChildren(depth);
    this->printSibling(depth);
};

void Tree::printSelf(int depth) {
    cout << tabPrint(depth) << "I have " << this->kind << " on line " << this->lineno << endl;
}

void Tree::printSibling(int depth) {

    int i = 0;
    Tree * sibling = this->sibling;

    while (sibling != NULL) {
        cout << tabPrint(depth) << "Sibling: " << ++i << endl;

        sibling->print(depth + 1);

        //move down the chain
        sibling = sibling->sibling;
    }
}

bool Tree::addSibling(Tree * node) {

    if (node == NULL) {
        return false;
    } else if (this->sibling == NULL) {
        this->sibling = node;
        this->sibling->siblingIndex = this->siblingIndex + 1;
        return true;
    }

    return this->addSiblingAux(this->sibling, node);
};

bool Tree::addSiblingAux(Tree * elder, Tree * node) {
    if (elder->sibling == NULL) {
        elder->sibling = node;
        return true;
    } else {
        return this->addSiblingAux(elder->sibling, node);
    }
}

bool Tree::addChild(Tree * child) {
    if (this->childCount >= this->maxChildren || child == NULL) {
        return false;
    } else {
        this->children[this->childCount] = child;
        this->childCount++;

        return true;
    }
}

void Tree::printChildren(int depth) {

    int j = 0;

    for (int i = 0; i < this->maxChildren; i++) {
        if (this->children[i] == NULL) {
            break;
        } else {
            cout << tabPrint(depth) << "Child: " << ++j << endl;
            this->children[i]->print(depth + 1);
        }
    }

}