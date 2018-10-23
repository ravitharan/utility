#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>

#define DEBUG  1

#define BUFFERSIZE 	0x100000 // linux code has around 174000
#define VERSION "1.0"
using namespace std;


typedef struct Module
{
  int LineNo ;
  string FileName ;
  string strModule;
} Module;

typedef vector<Module> VECTOR_MODULE;
typedef VECTOR_MODULE::iterator VECTOR_MODULE_ITERATOR;

const char HeaderFileName[] = "PrepPros_HeaderFile.h";

bool CompareModule (const Module& module1, const Module& module2)
{
  return (module1.strModule.compare(module2.strModule) < 0);
}

int main(int argc, char* argv[])
{
  ifstream InFileFiles;
  ifstream InSrcFile;
  ofstream OutFile;

  VECTOR_MODULE vecOfModule;
  Module AModule;
  bool IsModuleInList ;
  static char Buffer[BUFFERSIZE];
  char BufFileNme[256];
  string strPPFileName;
  string strPPOutFileName;
  string strSrcFileName;
  string strCrntLine;
  string str;
  int lineno ;

  if (argc != 2)
  {
    cerr << "Argument error, please enter File name, which contain source file list" << endl;
    return 0 ;
  }
  //	Form list of modules from this source file

  cout << "Ver " << VERSION << endl ;

  InFileFiles.open(argv[1]);
  if(InFileFiles.fail())
  {
    cerr << "Error: Cannot open input file \"" << argv[1] << "\"" << endl;
    return 0;
  }

  while( !InFileFiles.eof())
  {
    InFileFiles.getline(BufFileNme, 255);   //Get next file
    strCrntLine.assign(BufFileNme);

    if( strCrntLine.find_first_not_of(" \t") == string::npos) //remove blank lines
      continue;

    istringstream ins ( strCrntLine ) ;
    strSrcFileName.clear() ;
    ins >> strPPFileName >> strSrcFileName ;

    if ( strSrcFileName.empty() )
      strSrcFileName = strPPFileName.substr(0, strPPFileName.length() - 1 ) + "c" ;

    strPPOutFileName = strPPFileName + ".c" ;
#if ( DEBUG > 0 )
    cout << " Reading file \"" << strPPFileName << "\" source \"" << strSrcFileName << "\"\n";
#endif
    InSrcFile.open(strPPFileName.c_str());
    if(InSrcFile.fail())
    {
      cerr << "Error: Cannot open input file \"" << strPPFileName << "\"" << endl;
      vecOfModule.clear();
      return 1;
    }

    OutFile.open(strPPOutFileName.c_str());
    if(OutFile.fail())
    {
      cerr << "  Error: Cannot open output file \"" << strPPOutFileName << "\"" << endl;
      vecOfModule.clear();
      return 1;
    }

    lineno = 0 ;
    AModule.strModule.clear() ;
    while( !InSrcFile.eof())
    {
      InSrcFile.getline(Buffer, BUFFERSIZE-1);
      strCrntLine.assign(Buffer);
      lineno++ ;
      if( strCrntLine.find_first_not_of(" \t") == string::npos) //remove blank lines
        continue;

      strCrntLine += "\n" ;

      if( strCrntLine.at(0) == '#' )
      {
#if ( DEBUG > 2 )
        cout << "# " << lineno ;
#endif
        if ( ! AModule.strModule.empty() )
        {
#if ( DEBUG > 2 )
          cout << " data from " << AModule.FileName ;
#endif
          if ( AModule.FileName.find( strSrcFileName ) != string::npos )
          {
#if ( DEBUG > 1 )
            cout << " c contents " << endl ;
#endif
            OutFile << AModule.strModule ;
            while( !InSrcFile.eof() )
            {
              InSrcFile.getline(Buffer, BUFFERSIZE-1);
              strCrntLine.assign(Buffer);
              lineno++ ;
              if( strCrntLine.find_first_not_of(" \t") == string::npos) //remove blank lines
                continue;
              if( strCrntLine.at(0) == '#' )
                continue;
              strCrntLine += "\n" ;
              OutFile << strCrntLine ;
            }
          }
          else
          {
#if ( DEBUG > 1 )
            cout << " h contents " << endl ;
#endif
            IsModuleInList = false;
            for(VECTOR_MODULE_ITERATOR it = vecOfModule.begin(); it != vecOfModule.end(); it++)
            {
              if ( ( it->LineNo == AModule.LineNo ) && ( it->FileName == AModule.FileName ) && ( it->strModule == AModule.strModule ) )
              {
                IsModuleInList = true;
                break;
              }
            }
            if(IsModuleInList == false)
            {
              vecOfModule.push_back(AModule);
            }
          }
          AModule.strModule.clear() ;
        }
        else
        {
#if ( DEBUG > 2 )
          cout << " empty " << endl ;
#endif
        }
        istringstream ins ( strCrntLine ) ;
        ins >> str ;
        ins >> AModule.LineNo ;
        ins >> AModule.FileName ;
        AModule.strModule.clear() ;
      }
      else
      {
        AModule.strModule += strCrntLine ;
      }
    }

    if ( ! AModule.strModule.empty() )
    {
      if ( AModule.FileName.find( strSrcFileName ) != string::npos )
      {
#if ( DEBUG > 1 )
        cout << strPPFileName << ": " << lineno << endl ;
#endif
        OutFile << AModule.strModule ;
      }
      else
      {
        IsModuleInList = false;
        for(VECTOR_MODULE_ITERATOR it = vecOfModule.begin(); it != vecOfModule.end(); it++)
        {
          if ( ( it->LineNo == AModule.LineNo ) && ( it->FileName == AModule.FileName ) && ( it->strModule == AModule.strModule ) )
          {
            IsModuleInList = true;
            break;
          }
        }
        if(IsModuleInList == false)
        {
          vecOfModule.push_back(AModule);
        }
      }
      AModule.strModule.clear() ;
    }

    InSrcFile.close();
    InSrcFile.clear();
    OutFile.close() ;
  }
  InFileFiles.close();
  InFileFiles.clear();

  OutFile.open(HeaderFileName);
  if(OutFile.fail())
  {
    cerr << "  Error: Cannot open output file \"" << HeaderFileName << "\"" << endl;
    vecOfModule.clear();
    return 0;
  }
  sort(vecOfModule.begin(), vecOfModule.end(), CompareModule);
  for(VECTOR_MODULE_ITERATOR it = vecOfModule.begin(); it != vecOfModule.end(); it++)
  {
    OutFile << it->strModule;
  }

  vecOfModule.clear();

  OutFile.close();

  return 0;
}

