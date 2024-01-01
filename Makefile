##############################################################
###                                                        ###
### Makefile: local makefile for libsi                     ###
###                                                        ###
##############################################################

## $Revision: 1.1 $
## $Date: 2003/10/22 15:12:04 $
## $Author: rdp123 $
##
##   (C) 2001 Rolf Hakenes <hakenes@hippomi.de>, under the GNU GPL.
##
## dtv_scan is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2, or (at your option)
## any later version.
##
## dtv_scan is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You may have received a copy of the GNU General Public License
## along with dtv_scan; see the file COPYING.  If not, write to the
## Free Software Foundation, Inc., 59 Temple Place - Suite 330,
## Boston, MA 02111-1307, USA.
#
#
#

.DELETE_ON_ERROR:

CC = gcc
CFLAGS ?= -g -Wmissing-prototypes -Wstrict-prototypes \
         -DNAPI -Wimplicit -D__USE_FIXED_PROTOTYPES__ # -ansi -pedantic 

INCDIRS = -I../../../../../DVB 
DISTDIR = ../lib
MAKEDEPEND = gcc -M

LIBS = -lsi -llx

AR = ar
ARFLAGS = ru
RANLIB = ranlib

SILIB = libdsmcc.a
OBJS = dsmcc-receiver.o dsmcc-util.o dsmcc-descriptor.o dsmcc-biop.o dsmcc-carousel.o dsmcc-cache.o dsmcc.o

all : $(SILIB)

clean :
	@echo cleaning workspace...
	@rm -f $(OBJS) $(SILIB) *~
	@rm -f Makefile.dep

depend : Makefile.dep
Makefile.dep :
	@echo "updating dependencies..."
	@$(MAKEDEPEND) $(INCDIRS) $(OBJS:%.o=%.c) $(SITEST_OBJS:%.o=%.c) \
           $(SISCAN_OBJS:%.o=%.c) > Makefile.dep

new : clean depend all

dist: all
	@echo "distributing $(SILIB) to $(DISTDIR)..."
	@cp $(SILIB) $(DISTDIR)
	@cp $(INCLUDES) $(DISTINCDIR)
	@$(RANLIB) $(DISTDIR)/$(SILIB)

$(SILIB) : $(OBJS)
	@echo updating library...
	@$(AR) $(ARFLAGS) $(SILIB) $(OBJS)
	@$(RANLIB) $(SILIB)

.c.o : 
	@echo compiling $<...
	@$(CC) $(DEFINES) $(CFLAGS) $(INCDIRS) -c $<

-include Makefile.dep