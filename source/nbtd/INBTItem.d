module nbtd.INBTItem;

import nbtd;

import std.conv;

enum NBTType : ubyte
{
	End = cast(ubyte)0,
	Byte,
	Short,
	Int,
	Long,
	Float,
	Double,
	ByteArray,
	String,
	List,
	Compound,
	IntArray,
}

interface INBTItem
{
	@property NBTType type();
	@property int size();

	@property string name();
	@property void name(string name);

	@property T value(T)();
	@property void value(T)(T value);

	ubyte[] encode(bool compressed = true, bool hasName = true);

	void decode(ubyte[] data, bool compressed = true, bool hasName = true);

	void read(ref ubyte[] stream, bool hasName = true);

	@property INBTItem dup();

	final NBTByte asByte() { assert(type == NBTType.Byte, "Expected Byte, got " ~ to!string(type)); return cast(NBTByte)this; }
	final NBTShort asShort() { assert(type == NBTType.Short, "Expected Short, got " ~ to!string(type)); return cast(NBTShort)this; }
	final NBTInt asInt() { assert(type == NBTType.Int, "Expected Int, got " ~ to!string(type)); return cast(NBTInt)this; }
	final NBTLong asLong() { assert(type == NBTType.Long, "Expected Long, got " ~ to!string(type)); return cast(NBTLong)this; }
	final NBTFloat asFloat() { assert(type == NBTType.Float, "Expected Float, got " ~ to!string(type)); return cast(NBTFloat)this; }
	final NBTDouble asDouble() { assert(type == NBTType.Double, "Expected Double, got " ~ to!string(type)); return cast(NBTDouble)this; }
	final NBTByteArray asByteArray() { assert(type == NBTType.ByteArray, "Expected ByteArray, got " ~ to!string(type)); return cast(NBTByteArray)this; }
	final NBTString asString() { assert(type == NBTType.String, "Expected String, got " ~ to!string(type)); return cast(NBTString)this; }
	final NBTList asList() { assert(type == NBTType.List, "Expected List, got " ~ to!string(type)); return cast(NBTList)this; }
	final NBTCompound asCompound() { assert(type == NBTType.Compound, "Expected Compound, got " ~ to!string(type)); return cast(NBTCompound)this; }
	final NBTIntArray asIntArray() { assert(type == NBTType.IntArray, "Expected IntArray, got " ~ to!string(type)); return cast(NBTIntArray)this; }
}
