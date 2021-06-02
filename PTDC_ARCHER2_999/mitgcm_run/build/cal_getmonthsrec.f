












CBOP
C !ROUTINE: CAL_OPTIONS.h
C !INTERFACE:
C #include "CAL_OPTIONS.h"

C !DESCRIPTION:
C *==================================================================*
C | CPP options file for Calendar (cal) package:
C | Control which optional features to compile in this package code.
C *==================================================================*
CEOP







C $Header: /u/gcmpack/MITgcm/verification/isomip/code/CPP_OPTIONS.h,v 1.1 2006/09/01 16:11:09 mlosch Exp $
C $Name: checkpoint62r $


C CPP flags controlling particular source code features
C

C o Shortwave heating as extra term in external_forcing.F
C Note: this should be a run-time option

C o Include/exclude phi_hyd calculation code

C o Include/exclude call to S/R CONVECT

C o Include/exclude call to S/R CALC_DIFFUSIVITY

C o Include/exclude Implicit vertical advection code

C o Include/exclude AdamsBashforth-3rd-Order code

C o Include/exclude nonHydrostatic code

C o Include pressure loading code

C o Use "Exact Convervation" of fluid in Free-Surface formulation
C   so that d/dt(eta) is exactly equal to - Div.Transport

C o Allow the use of Non-Linear Free-Surface formulation
C   this implies that surface thickness (hFactors) vary with time

C o ALLOW isotropic scaling of harmonic and bi-harmonic terms when
C   using an locally isotropic spherical grid with (dlambda) x (dphi*cos(phi))
C *only for use on a lat-lon grid*
C   Setting this flag here affects both momentum and tracer equation unless
C   it is set/unset again in other header fields (e.g., GAD_OPTIONS.h).
C   The definition of the flag is commented to avoid interference with
C   such other header files.
C   The preferred method is specifying a value for viscAhGrid or viscA4Grid
C   in data which is then automatically scaled by the grid size;
C   the old method of specifying viscAh/viscA4 and this flag is provided
C   for completeness only (and for use with the adjoint).
C#define ISOTROPIC_COS_SCALING

C o This flag selects the form of COSINE(lat) scaling of bi-harmonic term.
C *only for use on a lat-lon grid*
C   Has no effect if ISOTROPIC_COS_SCALING is undefined.
C   Has no effect on vector invariant momentum equations.
C   Setting this flag here affects both momentum and tracer equation unless
C   it is set/unset again in other header fields (e.g., GAD_OPTIONS.h).
C   The definition of the flag is commented to avoid interference with
C   such other header files.
C#define COSINEMETH_III

C o Use "OLD" UV discretisation near boundaries (*not* recommended)
C   Note - only works with  #undef NO_SLIP_LATERAL  in calc_mom_rhs.F
C          because the old code did not have no-slip BCs

C o Execution environment support options
CBOP
C     !ROUTINE: CPP_EEOPTIONS.h
C     !INTERFACE:
C     include "CPP_EEOPTIONS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP\_EEOPTIONS.h                                         |
C     *==========================================================*
C     | C preprocessor "execution environment" supporting        |
C     | flags. Use this file to set flags controlling the        |
C     | execution environment in which a model runs - as opposed |
C     | to the dynamical problem the model solves.               |
C     | Note: Many options are implemented with both compile time|
C     |       and run-time switches. This allows options to be   |
C     |       removed altogether, made optional at run-time or   |
C     |       to be permanently enabled. This convention helps   |
C     |       with the data-dependence analysis performed by the |
C     |       adjoint model compiler. This data dependency       |
C     |       analysis can be upset by runtime switches that it  |
C     |       is unable to recoginise as being fixed for the     |
C     |       duration of an integration.                        |
C     |       A reasonable way to use these flags is to          |
C     |       set all options as selectable at runtime but then  |
C     |       once an experimental configuration has been        |
C     |       identified, rebuild the code with the appropriate  |
C     |       options set at compile time.                       |
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C=== Macro related options ===
C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working set size.
C     However, on vector CRAY systems this degrades performance.
C     Enable to switch REAL4_IS_SLOW from genmake2 (with LET_RS_BE_REAL4):

C--   Control use of "double" precision constants.
C     Use D0 where it means REAL*8 but not where it means REAL*16

C--   Enable some old macro conventions for backward compatibility

C=== IO related options ===
C--   Flag used to indicate whether Fortran formatted write
C     and read are threadsafe. On SGI the routines can be thread
C     safe, on Sun it is not possible - if you are unsure then
C     undef this option.

C--   Flag used to indicate whether Binary write to Local file (i.e.,
C     a different file for each tile) and read are thread-safe.

C--   Flag to turn off the writing of error message to ioUnit zero

C--   Alternative formulation of BYTESWAP, faster than
C     compiler flag -byteswapio on the Altix.

C--   Flag to turn on old default of opening scratch files with the
C     STATUS='SCRATCH' option. This method, while perfectly FORTRAN-standard,
C     caused filename conflicts on some multi-node/multi-processor platforms
C     in the past and has been replace by something (hopefully) more robust.

C--   Flag defined for eeboot_minimal.F, eeset_parms.F and open_copy_data_file.F
C     to write STDOUT, STDERR and scratch files from process 0 only.
C WARNING: to use only when absolutely confident that the setup is working
C     since any message (error/warning/print) from any proc <> 0 will be lost.

C=== MPI, EXCH and GLOBAL_SUM related options ===
C--   Flag turns off MPI_SEND ready_to_receive polling in the
C     gather_* subroutines to speed up integrations.

C--   Control MPI based parallel processing
CXXX We no longer select the use of MPI via this file (CPP_EEOPTIONS.h)
CXXX To use MPI, use an appropriate genmake2 options file or use
CXXX genmake2 -mpi .
CXXX #undef  1

C--   Control use of communication that might overlap computation.
C     Under MPI selects/deselects "non-blocking" sends and receives.
C--   Control use of communication that is atomic to computation.
C     Under MPI selects/deselects "blocking" sends and receives.

C--   Control XY periodicity in processor to grid mappings
C     Note: Model code does not need to know whether a domain is
C           periodic because it has overlap regions for every box.
C           Model assume that these values have been
C           filled in some way.

C--   disconnect tiles (no exchange between tiles, just fill-in edges
C     assuming locally periodic subdomain)

C--   Always cumulate tile local-sum in the same order by applying MPI allreduce
C     to array of tiles ; can get slower with large number of tiles (big set-up)

C--   Alternative way of doing global sum without MPI allreduce call
C     but instead, explicit MPI send & recv calls. Expected to be slower.

C--   Alternative way of doing global sum on a single CPU
C     to eliminate tiling-dependent roundoff errors. Note: This is slow.

C=== Other options (to add/remove pieces of code) ===
C--   Flag to turn on checking for errors from all threads and procs
C     (calling S/R STOP_IF_ERROR) before stopping.

C--   Control use of communication with other component:
C     allow to import and export from/to Coupler interface.

C--   Activate some pieces of code for coupling to GEOS AGCM


CBOP
C     !ROUTINE: CPP_EEMACROS.h
C     !INTERFACE:
C     include "CPP_EEMACROS.h"
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP_EEMACROS.h
C     *==========================================================*
C     | C preprocessor "execution environment" supporting
C     | macros. Use this file to define macros for  simplifying
C     | execution environment in which a model runs - as opposed
C     | to the dynamical problem the model solves.
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C     Flag used to indicate which flavour of multi-threading
C     compiler directives to use. Only set one of these.
C     USE_SOLARIS_THREADING  - Takes directives for SUN Workshop
C                              compiler.
C     USE_KAP_THREADING      - Takes directives for Kuck and
C                              Associates multi-threading compiler
C                              ( used on Digital platforms ).
C     USE_IRIX_THREADING     - Takes directives for SGI MIPS
C                              Pro Fortran compiler.
C     USE_EXEMPLAR_THREADING - Takes directives for HP SPP series
C                              compiler.
C     USE_C90_THREADING      - Takes directives for CRAY/SGI C90
C                              system F90 compiler.






C--   Define the mapping for the _BARRIER macro
C     On some systems low-level hardware support can be accessed through
C     compiler directives here.

C--   Define the mapping for the BEGIN_CRIT() and  END_CRIT() macros.
C     On some systems we simply execute this section only using the
C     master thread i.e. its not really a critical section. We can
C     do this because we do not use critical sections in any critical
C     sections of our code!

C--   Define the mapping for the BEGIN_MASTER_SECTION() and
C     END_MASTER_SECTION() macros. These are generally implemented by
C     simply choosing a particular thread to be "the master" and have
C     it alone execute the BEGIN_MASTER..., END_MASTER.. sections.

CcnhDebugStarts
C      Alternate form to the above macros that increments (decrements) a counter each
C      time a MASTER section is entered (exited). This counter can then be checked in barrier
C      to try and detect calls to BARRIER within single threaded sections.
C      Using these macros requires two changes to Makefile - these changes are written
C      below.
C      1 - add a filter to the CPP command to kill off commented _MASTER lines
C      2 - add a filter to the CPP output the converts the string N EWLINE to an actual newline.
C      The N EWLINE needs to be changes to have no space when this macro and Makefile changes
C      are used. Its in here with a space to stop it getting parsed by the CPP stage in these
C      comments.
C      #define IF ( a .EQ. 1 ) THEN  IF ( a .EQ. 1 ) THEN  N EWLINE      CALL BARRIER_MS(a)
C      #define ENDIF    CALL BARRIER_MU(a) N EWLINE        ENDIF
C      'CPP = cat $< | $(TOOLSDIR)/set64bitConst.sh |  grep -v '^[cC].*_MASTER' | cpp  -traditional -P'
C      .F.f:
C      $(CPP) $(DEFINES) $(INCLUDES) |  sed 's/N EWLINE/\n/' > $@
CcnhDebugEnds

C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working
C     set size. However, on vector CRAY systems this degrades
C     performance.
C- Note: global_sum/max macros were used to switch to  JAM routines (obsolete);
C  in addition, since only the R4 & R8 S/R are coded, GLOBAL RS & RL macros
C  enable to call the corresponding R4 or R8 S/R.



C- Note: a) exch macros were used to switch to  JAM routines (obsolete)
C        b) exch R4 & R8 macros are not practically used ; if needed,
C           will directly call the corrresponding S/R.

C--   Control use of JAM routines for Artic network (no longer supported)
C     These invoke optimized versions of "exchange" and "sum" that
C     utilize the programmable aspect of Artic cards.
CXXX No longer supported ; started to remove JAM routines.
CXXX #ifdef LETS_MAKE_JAM
CXXX #define CALL GLOBAL_SUM_R8 ( a, b) CALL GLOBAL_SUM_R8_JAM ( a, b)
CXXX #define CALL GLOBAL_SUM_R8 ( a, b ) CALL GLOBAL_SUM_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RS ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RL ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RS ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RL ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #endif

C--   Control use of "double" precision constants.
C     Use d0 where it means REAL*8 but not where it means REAL*16

C--   Substitue for 1.D variables
C     Sun compilers do not use 8-byte precision for literals
C     unless .Dnn is specified. CRAY vector machines use 16-byte
C     precision when they see .Dnn which runs very slowly!

C--   Set the format for writing processor IDs, e.g. in S/R eeset_parms
C     and S/R open_copy_data_file. The default of I9.9 should work for
C     a long time (until we will use 10e10 processors and more)



C o Include/exclude code specific to the ECCO/SEALION version.
C   AUTODIFF or EXF package.
C   Currently controled by a single header file
C   For this to work, PACKAGES_CONFIG.h needs to be included!
cph#if (defined (ALLOW_AUTODIFF) || cph     defined (ALLOW_ECCO) || cph     defined ())
cph# include "ECCO_CPPOPTIONS.h"
cph#endif




C-- Package-specific Options & Macros go here


      subroutine cal_GetMonthsRec(
     O                             fac, first, changed,
     O                             count0, count1,
     I                             mytime, myiter, mythid
     &                           )

c     ==================================================================
c     SUBROUTINE cal_GetMonthsRec
c     ==================================================================
c
c     o Given the current model time or iteration number this routine
c       returns the corrresponding months that will have to be used in
c       order to interpolate monthly mean fields. The routine derives 
c       from *exf_GetMonthsRec* of the external forcing package.
c
c     started: Christian Eckert eckert@mit.edu 21-Apr-2000
c              - ported from the external forcing package and slightly
c                modified (10 --> nmonthyear-2, 12 --> nmonthyear).
c
c     changed: Patrick Heimbach heimbach@mit.edu 15-Jun-2000
c              - fixed bug for count1 = nmonthyear
c
c     ==================================================================
c     SUBROUTINE cal_GetMonthsRec
c     ==================================================================

      implicit none

c     == global variables ==

C     ==================================================================
C     HEADER calendar
C     ==================================================================
C
C     o This header file contains variables that are used by the
C       calendar tool. The calendar tool can be used in the ECCO
C       SEALION release of the MITgcmUV.
C
C     started: Christian Eckert eckert@mit.edu  30-Jun-1999
C     changed: Christian Eckert eckert@mit.edu  17-Dec-1999
C              - restructured the original version in order to have a
C                better interface to the MITgcmUV.
C
C     ==================================================================
C     HEADER calendar
C     ==================================================================

C   - Parameters of the numerical model:
C
C     modelStart       :: start time of the numerical model.
C     modelStartDate   :: start date of the numerical model.
C     modelEnd         :: end   time of the numerical model.
C     modelEndDate     :: end   date of the numerical model.
C     modelStep        :: timestep of the numerical model.
C     modelIntSteps    :: number of timestep that are to be performed.
C     modelIter0       :: the numerical models initial timestep number.
C     modelIterEnd     :: the models last timestep number.
C     modelStepsperday :: number of model time steps per day (<- removed).

C   - Parameters used by the calendar:
C
C     refDate          :: first day of the Gregorian Calendar.
C     nMonthYear       :: number months in a year.
C     nDayMonth        :: days per month depending on the year being a leap
C                         year or not. If the Model calendar is used a 360
C                         days year with 30 days months is used instead.
C     nDaysNoLeap      :: number of days in a usual year.
C     nDaysLeap        :: number of days in a leap year.
C     nMaxDayMonth     :: maximum number of days in a years month.
C     hoursPerDay      :: number of hours   in a calendars day.
C     minutesPerDay    :: number of minutes in a calendars day.
C     minutesPerHour   :: number of minutes in a calendars hour.
C     secondsPerDay    :: number of seconds in a calendars day.
C     secondsPerHour   :: number of seconds in a calendars hour.
C     secondsPerMinute :: number of seconds in a calendars minute.
C     cal_setStatus    :: status of calendar parms setting (0=none, 3=fully set)

      INTEGER nMonthYear
      PARAMETER ( nMonthYear = 12 )

      COMMON /CALENDAR_RL/
     &                modelStart,
     &                modelEnd,
     &                modelStep
      Real*8 modelStart
      Real*8 modelEnd
      Real*8 modelStep

      COMMON /CALENDAR_I/
     &               refDate,
     &               nDayMonth,
     &               nDaysNoLeap,
     &               nDaysLeap,
     &               nMaxDayMonth,
     &               hoursPerDay,
     &               minutesPerDay,
     &               minutesPerHour,
     &               secondsPerDay,
     &               secondsPerHour,
     &               secondsPerMinute,
     &               modelStartDate,
     &               modelEndDate,
     &               modelIter0,
     &               modelIterEnd,
     &               modelIntSteps,
     &               cal_setStatus,
     &               startdate_1,
     &               startdate_2

      INTEGER refDate(4)
      INTEGER nDayMonth(nMonthYear,2)
      INTEGER nDaysNoLeap
      INTEGER nDaysLeap
      INTEGER nMaxDayMonth
      INTEGER hoursPerDay
      INTEGER minutesPerDay
      INTEGER minutesPerHour
      INTEGER secondsPerDay
      INTEGER secondsPerHour
      INTEGER secondsPerMinute

      INTEGER modelStartDate(4)
      INTEGER modelEndDate(4)
      INTEGER modelIter0
      INTEGER modelIterEnd
      INTEGER modelIntSteps

      INTEGER cal_setStatus
      INTEGER startdate_1
      INTEGER startdate_2

C   calendarDumps :: When set, approximate months (30-31 days) and years (360-372 days)
C                    for parameters chkPtFreq, pChkPtFreq, taveFreq, SEAICE_taveFreq,
C                    KPP_taveFreq, and freq in pkg/diagnostics are converted to exact
C                    calendar months and years.  Requires pkg/cal.
      COMMON /CALENDAR_L/
     &               calendarDumps,
     &               usingModelCalendar,
     &               usingNoLeapYearCal,
     &               usingJulianCalendar,
     &               usingGregorianCalendar
      LOGICAL calendarDumps
      LOGICAL usingModelCalendar
      LOGICAL usingNoLeapYearCal
      LOGICAL usingJulianCalendar
      LOGICAL usingGregorianCalendar

C     theCalendar :: type of calendar to use; available:
C                    'model', 'gregorian' or 'noLeapYear'.
C     dayOfWeek   :: Week day number one is the week day of refDate.
C                    For the Gregorian calendar this is Friday, 15-Oct-1582.
C     monthOfYear :: Both available calendars are assumed to have twelve
C                    months.
      COMMON /CALENDAR_C/
     &                     theCalendar,
     &                     dayOfWeek,
     &                     monthOfYear
      CHARACTER*(20) theCalendar
      CHARACTER*(3) dayOfWeek(7)
      CHARACTER*(3) monthOfYear(nMonthYear)


c     == routine arguments ==

      Real*8     fac
      logical first
      logical changed
      integer count0
      integer count1
      Real*8     mytime
      integer myiter
      integer mythid

c     == local variables ==

      integer currentdate(4)
      integer midtime(4)
      integer middate(4)
      integer tempDate(4)
      integer middate0_1, middate0_2
      integer middate0(4)
      integer middate1_1, middate1_2
      integer middate1(4)
      integer prevdate(4)
      integer shifttime(4)
      integer startofmonth_1, startofmonth_2
      integer endofmonth_1,  endofmonth_2
      integer startofmonth(4)
      integer endofmonth(4)
      integer difftime(4)
      integer present
      integer previous
      integer next
      integer prevcount
      integer modelsteptime(4)

      Real*8     currentsecs
      Real*8     prevsecs
      Real*8     midsecs_np
      Real*8     diffsecs
      Real*8     midsecs

c     == end of interface ==

ce    --> Include a check whether the right calendar is used.

      shifttime(1) =  1
      shifttime(2) =  0
      shifttime(3) =  0
      shifttime(4) = -1

      call cal_TimeInterval( -modelstep, 'secs', modelsteptime,
     &                        mythid )

c     Determine the current date and the current month.
      call cal_GetDate( myiter, mytime, currentdate, mythid )

      present         = mod(currentdate(1)/100,100)
      startofmonth_1  = (currentdate(1)/100)*100 + 1
      startofmonth_2  = 0
      call cal_FullDate( startofmonth_1, startofmonth_2,
     &                   startofmonth, mythid )

      endofmonth_1    = (currentdate(1)/100)*100 +
     &                  ndaymonth(present,currentdate(3))
      endofmonth_2    = 235959
      call cal_FullDate( endofmonth_1, endofmonth_2,
     &                   endofmonth, mythid )

c     Determine middle of current month.
      currentsecs = float(
     &              (mod(currentdate(1),100)-1)*secondsperday +
     &              currentdate(2)/10000*secondsperhour +
     &              mod(currentdate(2)/100,100)*secondsperminute +
     &              mod(currentdate(2),100)
     &              )
      midsecs     = float(ndaymonth(present,currentdate(3))*
     &                    secondsperday/2)

      call cal_TimeInterval( midsecs, 'secs', midtime, mythid )
      call cal_AddTime( startofmonth, midtime, middate, mythid )
      call cal_AddTime( currentdate, modelsteptime, prevdate, mythid )

      prevsecs = float(
     &           (mod(prevdate(1),100)-1)*secondsperday +
     &           prevdate(2)/10000*secondsperhour +
     &           mod(prevdate(2)/100,100)*secondsperminute +
     &           mod(prevdate(2),100)
     &           )

c--   Set switches for reading new records.
      first = ((mytime - modelstart) .lt. 0.5*modelstep)

      if ( first ) then
        changed = .false.
      endif

      if ( currentsecs .lt. midsecs ) then

        count0    = mod(present+nmonthyear-2,nmonthyear)+1
        prevcount = count0

        shifttime(1) = -shifttime(1)
        call cal_AddTime( startofmonth, shifttime, middate0, mythid )
        middate0_1  = (middate0(1)/100)*100 + 1
        middate0_2  = 0
        call cal_FullDate( middate0_1, middate0_2, tempDate,
     &                     mythid )

        previous   = mod(tempDate(1)/100,100)

        midsecs_np = float(ndaymonth(previous,tempDate(3))*
     &                     secondsperday/2)

        call cal_TimeInterval( midsecs_np, 'secs', midtime, mythid )
        call cal_AddTime( tempDate, midtime, middate0, mythid )

        count1 = present

        middate1(1) = middate(1)
        middate1(2) = middate(2)
        middate1(3) = middate(3)
        middate1(4) = middate(4)

      else

        count0 = present

        if ( prevsecs .lt. midsecs ) then
          prevcount = mod(present+nmonthyear-2,nmonthyear)+1
        else
          prevcount = present
        endif

        middate0(1) = middate(1)
        middate0(2) = middate(2)
        middate0(3) = middate(3)
        middate0(4) = middate(4)

        count1 = mod(present+1,nmonthyear)
        if ( count1 .EQ. 0 ) count1 = nmonthyear

        call cal_AddTime( endofmonth, shifttime, middate1, mythid )
        middate1_1  = (middate1(1)/100)*100 + 1
        middate1_2  = 0

        call cal_FullDate( middate1_1, middate1_2, tempDate,
     &                     mythid )
        next       = mod(tempDate(1)/100,100)
        midsecs_np = float(ndaymonth(next,tempDate(3))*
     &                     secondsperday/2)
        call cal_TimeInterval( midsecs_np, 'secs', midtime, mythid )
        call cal_AddTime( tempDate, midtime, middate1, mythid )

      endif

      call cal_SubDates( middate1, middate0, difftime, mythid )
      call cal_ToSeconds( difftime, diffsecs, mythid )

c     Set counters, switches, and the linear interpolation factor.
      if ( (.not. first) .and. (prevcount .ne. count0) ) then
        changed = .true.
      else
        changed = .false.
      endif

      if ( currentsecs .lt. midsecs ) then
        fac = (midsecs - currentsecs)/diffsecs
      else
        fac = (2.*midsecs + midsecs_np - currentsecs)/
     &        diffsecs
      endif

      return
      end
