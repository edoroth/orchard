/*
Copyright (c) 2017, The University of Bristol, Senate House, Tyndall Avenue, Bristol, BS8 1TH, United Kingdom.
Copyright (c) 2018, COSIC-KU Leuven, Kasteelpark Arenberg 10, bus 2452, B-3001 Leuven-Heverlee, Belgium.

All rights reserved
*/
#ifndef _InputOutputFile
#define _InputOutputFile

/* A simple IO class which just uses standard
 * input/output to communicate values
 *
 * Whereas share values are input/output using
 * a steam, with either human or non-human form
 */

#include "Input_Output_Base.h"

#include <fstream>
using namespace std;

class Input_Output_File : public Input_Output_Base
{
  istream *fin;
  ostream *fout;
  istream *fsharein;
  ostream *fshareout;

  bool human; // Only affects share output

public:
  Input_Output_File()
      : Input_Output_Base()
  {
    ;
  }

  void init(istream &f_in, ostream &f_out, ifstream &f_sharein, ofstream &f_shareout, bool human_type)
  {
    fin = &f_in;
    fout = &f_out;
    fsharein = &f_sharein;
    fshareout = &f_shareout;
    human= human_type;
  }

  virtual long open_channel(unsigned int channel);
  virtual void close_channel(unsigned int channel);

  virtual gfp private_input_gfp(unsigned int channel);
  virtual void private_output_gfp(const gfp &output, unsigned int channel);

  virtual void public_output_gfp(const gfp &output, unsigned int channel);
  virtual gfp public_input_gfp(unsigned int channel);

  virtual void public_output_int(const long output, unsigned int channel);
  virtual long public_input_int(unsigned int channel);

  virtual void output_share(const Share &S, unsigned int channel);
  virtual Share input_share(unsigned int channel);

  virtual void trigger(Schedule &schedule);

  virtual void debug_output(const stringstream &ss);

  virtual void crash(unsigned int PC, unsigned int thread_num);
};

#endif
