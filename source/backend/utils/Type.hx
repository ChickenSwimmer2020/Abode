package backend.utils;

abstract OneOfTwo<T1, T2>(Dynamic) from T1 from T2 to T1 to T2 {}
abstract OneOfThree<T1, T2, T3>(Dynamic) from T1 from T2 from T3 to T1 to T2 to T3 {}
abstract OneOfFour<T1, T2, T3, T4>(Dynamic) from T1 from T2 from T3 from T4 to T1 to T2 to T3 to T4 {}