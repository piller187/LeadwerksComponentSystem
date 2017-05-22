#include "stdafx.h"
#include "Report.h"
#include <stdarg.h>  
#include <iostream>  


Report::Report()
{
}

Report::~Report()
{
}

Report& Report::instance()
{
	static Report inst;
	return inst;
}

void Report::write(const char * fmt, ...)
{
	char out[1024];
	va_list argptr;
	va_start(argptr, fmt);
	vsnprintf(out, sizeof(out), fmt, argptr);
	va_end(argptr);
	std::cerr << "MapParse: " << out << std::endl;
}

void Report::error(const char * fmt, ...)
{
	char out[1024];
	va_list argptr;
	va_start(argptr, fmt);
	vsnprintf(out, sizeof(out), fmt, argptr);
	va_end(argptr);
	std::cerr << "MapParse: ### ERROR ### " << out << std::endl;
}

