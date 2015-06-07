module nbtd.INBTItem;

import nbtd;

import std.conv;

/// Enum for all NBT Types.
enum NBTType : ubyte
{
	End = cast(ubyte)0, ///
	Byte, ///
	Short, ///
	Int, ///
	Long, ///
	Float, ///
	Double, ///
	ByteArray, ///
	String, ///
	List, ///
	Compound, ///
	IntArray, ///
}

/// Interface for all NBT TAGs containing convertion functions and virtual functions for type, size, name, value, encoding, decoding and reading from a stream.
interface INBTItem
{
	/// Returns: the type of the NBT Item.
	@property NBTType type();
	/// Returns: the size in bytes of the NBT Item without name.length, name or TAG ID.
	@property int size();

	/// Returns: the name of the Item as UTF-8 string.
	@property string name();
	/// Sets the name of the Item as UTF-8 string.
	@property void name(string name);

	/// Returns: the current value as specified in the child classes.
	@property T value(T)();
	/// Sets the current value and possible checks the input in the child classes.
	@property void value(T)(T value);

	/// Encodes the item to a ubyte[] that can be compressed and/or written without name and TAG ID.
	/// Params:
	/// 	compressed = When true, the resulting ubyte[] will be GZip compressed.
	/// 	hasName    = When false, name and TAG ID will be omitted.
	ubyte[] encode(bool compressed = true, bool hasName = true);

	/// Decodes the item from a ubyte[] that can be compressed and/or read without name and TAG ID and stores the results in `this`.
	/// Params:
	/// 	compressed = When true, the ubyte[] will get uncompressed for decoding.
	/// 	hasName    = When false, reading won't try to read a name and `this.name` will be set to `""`.
	void decode(ubyte[] data, bool compressed = true, bool hasName = true);

	/// Decodes the item from a ubyte[] stream that can be read without name and TAG ID and stores the results in `this` and advances the stream.
	/// Params:
	/// 	hasName    = When false, reading won't try to read a name and `this.name` will be set to `""`.
	void read(ref ubyte[] stream, bool hasName = true);

	/// Duplicates the Item.
	@property INBTItem dup();

	final NBTByte asByte() { assert(type == NBTType.Byte, "Expected Byte, got " ~ to!string(type)); return cast(NBTByte)this; } /// Will check if the type is `NBTType.Byte` and return `this` as `NBTByte`
	final NBTShort asShort() { assert(type == NBTType.Short, "Expected Short, got " ~ to!string(type)); return cast(NBTShort)this; } /// Will check if the type is `NBTType.Short` and return `this` as `NBTShort`
	final NBTInt asInt() { assert(type == NBTType.Int, "Expected Int, got " ~ to!string(type)); return cast(NBTInt)this; } /// Will check if the type is `NBTType.Int` and return `this` as `NBTInt`
	final NBTLong asLong() { assert(type == NBTType.Long, "Expected Long, got " ~ to!string(type)); return cast(NBTLong)this; } /// Will check if the type is `NBTType.Long` and return `this` as `NBTLong`
	final NBTFloat asFloat() { assert(type == NBTType.Float, "Expected Float, got " ~ to!string(type)); return cast(NBTFloat)this; } /// Will check if the type is `NBTType.Float` and return `this` as `NBTFloat`
	final NBTDouble asDouble() { assert(type == NBTType.Double, "Expected Double, got " ~ to!string(type)); return cast(NBTDouble)this; } /// Will check if the type is `NBTType.Double` and return `this` as `NBTDouble`
	final NBTByteArray asByteArray() { assert(type == NBTType.ByteArray, "Expected ByteArray, got " ~ to!string(type)); return cast(NBTByteArray)this; } /// Will check if the type is `NBTType.ByteArray` and return `this` as `NBTByteArray`
	final NBTString asString() { assert(type == NBTType.String, "Expected String, got " ~ to!string(type)); return cast(NBTString)this; } /// Will check if the type is `NBTType.String` and return `this` as `NBTString`
	final NBTList asList() { assert(type == NBTType.List, "Expected List, got " ~ to!string(type)); return cast(NBTList)this; } /// Will check if the type is `NBTType.List` and return `this` as `NBTList`
	final NBTCompound asCompound() { assert(type == NBTType.Compound, "Expected Compound, got " ~ to!string(type)); return cast(NBTCompound)this; } /// Will check if the type is `NBTType.Compound` and return `this` as `NBTCompound`
	final NBTIntArray asIntArray() { assert(type == NBTType.IntArray, "Expected IntArray, got " ~ to!string(type)); return cast(NBTIntArray)this; } /// Will check if the type is `NBTType.IntArray` and return `this` as `NBTIntArray`
}
