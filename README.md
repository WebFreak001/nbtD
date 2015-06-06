# nbtd

A small NBT encoding and decoding library for D.

It supports all Data TAGs in version 19133 and contains a simple API.

## Examples

### Hello World

```D
import std.file;

import nbtd;

void main(string[] args)
{
	NBTString helloWorld = new NBTString("Hello World");
	write("helloWorld.nbt.gz", helloWorld.encode(true, false));
	// helloWorld.nbt.gz will now contain this binary string compressed:
	// 11               Hello World
	// String Length    UTF-8 string
	//
	// TAG-ID and Name are not written when hasName is false
}
```

### Encoding & Decoding

```D
import std.file;

import nbtd;

void main(string[] args)
{
	NBTCompound level = new NBTCompound();
	level.name = "Level";
	level["players"] = new NBTList([new NBTString("Foo"), new NBTString("Bar")]);
	level["seed"] = new NBTLong(48968643157);

	write("level.nbt.gz", level.encode());
	write("level.nbt", level.encode(false));

	NBTCompound imported = new NBTCompound();
	imported.decode(cast(ubyte[])read("level.nbt.gz"));
	assert(imported.name == "Level");
	assert(imported["players"].asList().length == 2);
	assert(imported["players"].asList()[0].asString().value == "Foo");
	assert(imported["players"].asList()[1].asString().value == "Bar");
	assert(imported["seed"].asLong().value == 48968643157);
}
```

## TODO

- [ ] Encoding/Decoding using class schemas
- [ ] Easier interface for files
- [x] Encoding/Decoding ubyte[]
- [x] Encoding/Decoding gzip'd ubyte[]
- [x] Support all 19133 TAGs
