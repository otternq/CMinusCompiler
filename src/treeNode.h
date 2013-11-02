#define MAXCHILDREN = 3;

typedef struct treeNode
{
    // connectivity in the tree
    struct treeNode *child[MAXCHILDREN];   // children of the node
    struct treeNode *sibling;              // siblings for the node

    // what kind of node
    int lineno;                            // linenum relevant to this node

    NodeKind nodekind;                     // type of node

    union                                  // subtype of type
    {
        DeclKind decl;                     // used when DeclK
        StmtKind stmt;                     // used when StmtK
        ExpKind exp;                       // used when ExpK
    } kind;
    
    // extra properties about the node depending on type of the node
    union                                  // relevant data to type -> attr
    {
        OpKind op;                         // type of token (same as in bison)
        int val;                           // used when an integer constant
        char *name;                        // used when IdK
        char *string;                      // used when a string constant
    } attr;


    ExpType expType;                   // used when ExpK for type checking

    bool isStatic;                         // is staticly allocated?
    bool isArray;                          // is this an array
    bool isConstant;                       // can this expression be precomputed?

    // even more semantic stuff will go here in later assignments.
} TreeNode;