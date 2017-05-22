#pragma once
#include <string>
#include <fstream>
#include <vector>

class MapParser
{
	std::ifstream inStream;
	std::ofstream outStream;
	std::vector<std::string> names;
	std::vector<std::string> strings;
	
	size_t rdPos;
	int posStrings;
	int posObjects;
	int posMapInfo;
	int posTerrainInfo;
	int posNavmeshInfo;
	int posDependencies;
	int version;


	void rdPositon(size_t pos);
	std::string rdString(size_t len);
	std::string rdString();

	int rdInt();
	float rdFloat();

	void parseStrings(size_t pos);
	void parseObjects(size_t pos);
	void parseObject();

public:
	MapParser();
	~MapParser();

	bool parse(const std::string& source, const std::string& dest);
};

