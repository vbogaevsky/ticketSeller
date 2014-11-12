program ticketSeller;

const
  Price = 20;

type
  tableShort = array[1..4, 1..3] of byte;
  tableLong = array[1..4, 1..6] of integer;

var
  ans: char;
  time: integer;
  departure, destination, stops, i, j: byte;
  fromAtoD, fromDtoA: tableShort;
  timeTable: tableLong;
  work, direction, full: boolean;

procedure printTimeTable();
begin
  println(' ___________________________________ ');
  println('|                 |                 |');
  println('|   From A to D   |   From D to A   |');
  println('|_________________|_________________|');
  println('|     |     |     |     |     |     |');
  println('|  A  |  B  |  C  |  D  |  C  |  B  |');
  println('|_____|_____|_____|_____|_____|_____|');
  println('|     |     |     |     |     |     |');
  println('| 7:00| 7:40| 8:20| 9:00| 9:40|10:20|');
  println('|_____|_____|_____|_____|_____|_____|');
  println('|     |     |     |     |     |     |');
  println('|11:00|11:40|12:20|13:00|13:40|14:20|');
  println('|_____|_____|_____|_____|_____|_____|');
  println('|     |     |     |     |     |     |');
  println('|15:00|15:40|16:20|17:00|17:40|18:40|');
  println('|_____|_____|_____|_____|_____|_____|');
  println('|     |     |     |     |     |     |');
  println('|19:00|19:40|20:20|21:00|21:40|22:20|');
  println('|_____|_____|_____|_____|_____|_____|');
end;

procedure welcomer(var depr, dest: byte; var tm: integer);
var
  req: string[9];
  flag: boolean;
  i: byte;
begin
  printTimeTable();
  flag := true;
  while flag do
  begin
    writeln;
    writeln('Please, input departure,destination and time of departure from time table');
    writeln('(ie: A D 07:00):');
    readln(req);
    for i := 1 to 9 do
      req[i] := upcase(req[i]);
    if ((req[1] >= 'A') and (req[1] <= 'D') and (req[3] >= 'A')
            and (req[3] <= 'D') and (req[1] <> req[3])) then
    begin
      flag := false;
      depr := ord(req[1]) - 64;
      dest := ord(req[3]) - 64;
      tm := (ord(req[5]) * 10  + ord(req[6])) * 60 + ord(req[8]) * 10 + ord(req[9]) - ord('0') * 671;
    end 
    else writeln('Incorrect input');  
  end
end;

procedure fillTimeTable(var t: tableLong);
var
  i, j: byte;
begin
  t[1, 1] := 420;
  for i := 2 to 4 do
    t[i, 1] := t[i - 1, 1] + 240;
  for i := 1 to 4 do
    for j := 2 to 6 do
      t[i, j] := t[i, j - 1] + 40;
end;

function timeSearch(var t: tableLong; var depr: byte; var tm: integer): integer;
var
  i: byte;
begin
  for i := 1 to 4 do
  begin
    if t[i, depr] = tm then
    begin
      timeSearch := i;
    end
  end
end;

begin
  work := true;
  for i := 1 to 4 do
    for j := 1 to 3 do
    begin
      fromAtoD[i, j] := 0;
      fromDtoA[i, j] := 0;
    end;
  fillTimeTable(timeTable);
  while work do
  begin
    direction := true;
    full := false;
    welcomer(departure, destination, time);
    stops := abs(departure - destination);
    if departure > destination then
    begin
      direction := false;
      case departure of
        2: departure := departure + 4;
        3: departure := departure + 2;
      end
    end;    
    time := timeSearch(timeTable, departure, time);
    if direction then
    begin
      for i := departure to stops do
      begin
        if fromAtoD[time, i] < 3 then
          fromAtoD[time, i] := fromAtoD[time, i] + 1          
        else full := true
      end;
    end
    else
    begin
      departure := departure - 3;
      for i := departure to stops do
      begin
        if fromDtoA[time, departure] < 3 then
          fromDtoA[time, i] := fromDtoA[time, i] + 1              
        else full := true
      end
    end;
    if full then
      writeln('No seats are available for this time and route.')
    else writeln('Ticket cost is ', Price * stops, '.');
    writeln('Sell another ticket? (Y/N)');
    readln(ans);
    if ((ans = 'N') or (ans = 'n')) then
      work := false;
  end
end.
