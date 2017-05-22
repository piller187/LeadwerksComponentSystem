#include "stdafx.h"
#include "MapParser.h"
#include "Report.h"
#include <string>
#include <vector>

MapParser::MapParser()
{
}


MapParser::~MapParser()
{
}

bool MapParser::parse(const std::string& source, const std::string& dest)
{
	inStream.open(source.c_str(), std::ios_base::in | std::ios_base::binary );
	if (!inStream.is_open())
	{
		Report::instance().error("Failed to open source %s", source.c_str());
		return false;
	}

	outStream.open(dest.c_str());
	if (!outStream.is_open())
	{
		Report::instance().error("Failed to create destination %s", dest.c_str());
		return false;
	}

	Report::instance().write("Processing %s", source.c_str());

	//	Indentifier
	rdPos = 0;
	const std::string indentifier("SCEN");
	if ( rdString(indentifier.length()) != indentifier )
	{
		Report::instance().error("%s is not a MAP file", source.c_str());
		return false;
	}

	//  Version
	version = rdInt();
	Report::instance().write("Map file version is %d", version);
	if (version < 3 || version > 42)
	{
		Report::instance().error("Map version %d is not support", version);
		return false;
	}
	
	//  Positions
	posStrings = rdInt();
	posObjects = rdInt();
	posMapInfo = rdInt();

	if (version > 16)
	{
		posTerrainInfo = rdInt();
		posNavmeshInfo = rdInt();
	}

	if (version > 27)
	{
		posDependencies = rdInt();
	}

	parseStrings(posStrings);
	parseObjects(posObjects);

	for each (std::string name in names )
	{
		outStream << name << std::endl;
	}
	outStream.close();
	inStream.close();
	Report::instance().write("Done!");
	Report::instance().write("Result written to %s", dest.c_str());
	return true;
}

std::string MapParser::rdString( size_t len)
{
	std::string buf;
	buf.resize(len);

	inStream.read(&buf[0], len);
	rdPos += len;
	return buf;
}

std::string MapParser::rdString()
{
	std::string buf;

	char c = '\0';
	do
	{
		inStream.read(&c, sizeof(char) ); 
		if (c != '\0')
		{
			buf.push_back(c);
		}
		rdPos++;
	} while (c != '\0');

	return buf;
}

void MapParser::rdPositon(size_t pos)
{
	inStream.clear();
	inStream.seekg(pos);
}

int MapParser::rdInt()
{
	int value = 0;
	inStream.read(reinterpret_cast<char*>(&value), sizeof(value));
	rdPos += sizeof(value);
	return value;
}

float MapParser::rdFloat()
{
	float value = 0.0f;
	inStream.read(reinterpret_cast<char*>(&value), sizeof(value));
	rdPos += sizeof(value);
	return value;
}

void MapParser::parseStrings(size_t pos)
{
	//	Read strings
	rdPositon(pos);
	inStream.seekg(posStrings);
	int strCount = rdInt();
	for (int ii = 0; ii < strCount; ii++)
	{
		strings.push_back(rdString());
	}
}

void MapParser::parseObjects(size_t pos)
{
	rdPositon(pos);
	int count = rdInt();
	for (int ii = 0; ii < count; ii++)
	{
		parseObject();
	}
}

void MapParser::parseObject()
{
	int objectSize = 0;
	if (version > 9)
	{
		objectSize = rdInt();
	}

	int objectStart = static_cast<int>(inStream.tellg());
	int classid = rdInt();
	int objectid = rdInt();
	rdInt(); // skip 

	if (version > 8)
	{
		rdInt(); // shadowmode
	}

	if (version < 21)
	{
		float pos[3];
		for (int i = 0; i < 3; i++) pos[i] = rdFloat();
	
		float rot[3];
		for (int i = 0; i < 3; i++) rot[i] = rdFloat();
		
		float scale[3];
		for (int i = 0; i < 3; i++) scale[i] = rdFloat();
	}
	else
	{
		if (version > 34)
		{
			if (version > 41)
			{
				float px = rdFloat(); 
				float py = rdFloat(); 
				float pz = rdFloat(); 
			}
			float pitch = rdFloat();
			float yaw = rdFloat();	
			float roll = rdFloat();	
			float qx = rdFloat();	
			float qy = rdFloat();	
			float qz = rdFloat();	
			float qw = rdFloat();	
			if (version > 41)
			{
				float sx = rdFloat(); 
				float sy = rdFloat(); 
				float sz = rdFloat(); 
			}
			
			float m[16]; // matrix = 16 floats
			for (int v = 0; v < 16; v++)
			{
				m[v]=rdFloat();
			}
		}
	}

	if (rdInt() != 0) // isprefab
	{
		// skipping prefab for now
		Report::instance().error("Prefabs are not supported");
	}
	else
	{
		names.push_back(strings[rdInt()]);
		Report::instance().write("Found %s", names.back().c_str());
		rdPositon(objectStart + objectSize);
	}
}
