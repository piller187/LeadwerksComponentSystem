// MapParse.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "MapParser.h"
#include "Report.h"

void usage()
{
	Report::instance().write("Usage: MapParse <leadwerks map file> <output file>");
}

int main( int argn, const char* args[] )
{
	Report::instance().write("Leadwerks Map Parser 1.0");
	if (argn < 3)
	{
		Report::instance().error("To few arguments!");
		usage();
		return 1;
	}

	MapParser map;

	map.parse(args[1], args[2]);
    return 0;
}

