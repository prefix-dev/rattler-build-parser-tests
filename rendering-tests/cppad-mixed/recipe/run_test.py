#! /usr/bin/env python
#
# example_file
# This file must be in the test.sources of meta.yaml
example_file = 'example/user/no_random.cpp'
#
# imports
import sys
import os
import subprocess
import platform
#
# system_command
# 1. print the command before executing it
# 2. double check for errors during the command
# 3 print any error message that is returned before aborting
def system_command(command) :
   print( " ".join( command ) )
   try :
      result = subprocess.run(
         command, 
         check          = False,
         capture_output = True , 
         encoding       = 'utf-8', 
         env            = os.environ
      )
   #
   except subprocess.CalledProcessErrror as e :
      if e.stdout != None and e.stdout != "" :
         print( e.stdout )
      sys.exit( e.stderr )
   #
   if result.stdout != None and result.stdout != "" :
      print( result.stdout )
   if result.returncode != 0 :
      sys.exit( result.stderr )
   return result.stdout
#
# main
# Put this code in a function so as to not polute the file namespace
def main() :
   #
   start_directory = os.getcwd().split('/')
   print( 'run_test.py: start_directory   = ', start_directory )
   if not os.path.isfile(example_file) :
      sys.exit( f'run_test.py: cannot find example file = {example_file}' )
   #
   # system
   system = platform.system()
   assert system in [ 'Linux', 'Darwin', 'Windows' ]
   print( f'system = {system}' )
   #
   # prefix, os.environ['PKG_CONFIG_PATH']
   prefix  = os.environ['PREFIX']
   if system == 'Windows' :
      prefix = f'{prefix}\\Library'
      os.environ['PKG_CONFIG_PATH']  = f'{prefix}\\lib\\pkgconfig'
      os.environ['PKG_CONFIG_PATH'] += f':{prefix}\\share\\pkgconfig'
   else :
      os.environ['PKG_CONFIG_PATH']  = f'{prefix}/lib/pkgconfig'
      os.environ['PKG_CONFIG_PATH'] += f':{prefix}/share/pkgconfig'
   prefix = prefix.replace( '\\' , '/' )
   #
   # cppad_mixed_lib
   path_dict = {
      'Linux'   : 'libcppad_mixed.so' ,
      'Darwin'  : 'libcppad_mixed.so' ,
      'Windows' : 'cppad_mixed.lib'
   }
   cppad_mixed_lib = path_dict[system]
   #
   # example_file
   assert example_file[-4 :] == '.cpp'
   #
   # example_function
   start            = example_file.rfind('/') + 1
   example_function = example_file[start : -4] + '_xam'
   #
   # test_install
   os.mkdir('test_install')
   os.chdir('test_install')
   #
   # main.cpp
   # Create C++ program that runs the example fucntion and check its result
   data = '''
# include <iostream>
# include <cstdlib>
extern bool EXAMPLE_FUNCTION(void); 

int main(void)
{  if( ! EXAMPLE_FUNCTION() )
   {  std::cout << "EXAMPLE_FUNCTION: Error" << std::endl;
      std::exit(1);
   }
   std::cout << "EXAMPLE_FUNCTION: OK" << std::endl;
   std::exit(0);
}
'''
   data = data.replace( 'EXAMPLE_FUNCTION', example_function )
   with open('main.cpp', 'w') as fobj :
      fobj.write(data)
   #
   # CMakeLists.txt
   # Create a project that compiles, links, and runs the C++ program.
   data = '''
cmake_minimum_required( VERSION 3.10 )
project( check_install )
message( STATUS CMAKE_SYSTEM_NAME = ${CMAKE_SYSTEM_NAME} )
message( STATUS PKG_CONFIG_PATH   = $ENV{PKG_CONFIG_PATH} )
#
# include_directories
# link_directories
find_package(PkgConfig)
foreach(pkg gsl eigen3 ipopt cppad)
   pkg_check_modules( ${pkg} QUIET ${pkg} )
   if( ${pkg}_FOUND )
      message(STATUS "Found ${pkg}.pc file")
   else( )
      message(FATAL_ERROR 
         "Cannot find *.pc file for ${pkg} or a package it requires"
      )
   endif( )
   include_directories( SYSTEM ${${pkg}_INCLUDE_DIRS} )
   link_directories( ${${pkg}_LIBRARY_DIRS} )
endforeach( )
#
# Kludge: CHOLMOD.pc is missing on conda-forge windows install
include_directories( SYSTEM PREFIX/include/suitesparse )
set( CHOLMOD_LIBRARIES "cholmod;amd;camd;colamd;ccolamd;suitesparseconfig" )

#
# check_main
add_executable( main main.cpp EXAMPLE_FILE ) 
if( NOT "${CMAKE_SYSTEM_NAME}" STREQUAL "Windows" )
   target_link_libraries(main cppad_mixed )
else( )
   # windwos is using static linkinging
   target_link_libraries( main cppad_mixed
      ${gsl_LIBRARIES}
      ${ipopt_LIBRARIES}
      ${CHOLMOD_LIBRARIES}
   )
endif( )
add_custom_target(check_main main)
'''
   data = data.replace( 'EXAMPLE_FILE',    f'../{example_file}' )
   data = data.replace( 'PREFIX',          prefix )
   with open('CMakeLists.txt', 'w') as fobj :
      fobj.write(data)
   #
   # test_install/build
   os.mkdir('build')
   os.chdir('build')
   #
   # cmake 
   command = [ 
      'cmake', 
      '-S', '..' , 
      '-B', '.'  ,
      '-D', 'CMAKE_BUILD_TYPE=Release' ,
   ]
   system_command( command )
   #
   # check_main
   command = [ 
      'cmake', 
      '--build',   '.', 
      '--config',  'Release', 
      '--target',  'check_main'
   ]
   system_command( command )
   #
   print( 'run_test.py: OK' )
#
#
# python main
if __name__ == "__main__" :
   main()
