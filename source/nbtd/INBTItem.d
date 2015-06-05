module nbtd.INBTItem;

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

	ubyte[] encode(bool compressed = true);

	void decode(ubyte[] data, bool compressed = true);
}
