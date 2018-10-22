string result;

struct A
{
    @implicit this(ref A rhs)
    {
        result ~= "A";
    }
    @implicit this(ref immutable A rhs)
    {
        result ~= "B";
    }
    @implicit this(ref const A rhs)
    {
        result ~= "C";
    }
    @implicit this(ref A rhs) immutable
    {
        result ~= "D";
    }
    @implicit this(ref const A rhs) shared
    {
        result ~= "E";
    }
    @implicit this(ref A rhs) shared
    {
        result ~= "F";
    }
    @implicit this(ref shared A rhs) immutable
    {
        result ~= "G";
    }
    @implicit this(ref shared A rhs) shared
    {
        result ~= "H";
    }
}

// copy constructor correctly uses function declaration overload resolution
void test1()
{
    result = "";
    A a;
    A a1 = a;
    immutable A a2 = a;
    const A a3 = a2;
    shared A a4 = a3;
    A a5 = a3;
    assert(result == "ADBEC");
}

// copy constructor has priority over alias this
struct B
{
    B fun(immutable B)
    {
        return B();
    }

    @implicit this(ref immutable B rhs)
    {
        result ~= "A";
    }
    alias fun this;
}

void test2()
{
    result = "";
    immutable B a;
    B a1 = a;
    assert(result == "A");
}

// arguments and return values correctly call the copy constructor
shared(A) fun(A x)
{
    return x;
}

immutable(A) fun2(shared A x)
{
    return x;
}

void test3()
{
    result = "";
    A a1;
    shared A a2 = fun(a1);
    immutable A a3 = fun2(a2);
    assert(result == "AFHG");
}

// nested structs
int fun()
{
    int x = 1;
    struct A
    {
        struct B
        {
            int x2 = 2;
        }

        B b;
        int x1;

        this(int x)
        {
            this.x1 = x;
            b = B(3);
        }
        @implicit this(ref A rhs)
        {
            this.x1 = rhs.x1 + rhs.b.x2 + x;
        }
    }

    A a = A(2);
    A b = a;
    return b.x1;
}

void test4()
{
    assert(fun() == 6);
}

void main()
{
    test1();
    test2();
    test3();
    test4();
}
