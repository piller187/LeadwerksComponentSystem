#pragma once
class Report
{
	Report();
public:
	~Report();

	static Report& instance();
	void write(const char* fmt, ...);
	void error(const char* frm, ...);
};

