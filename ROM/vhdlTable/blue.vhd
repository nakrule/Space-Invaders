type memoryPicture is array(0 to 29, 0 to 29) of integer;
constant picture : memoryPicture:=(
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#21#,16#21#,16#4#,16#4#,16#4#,16#4#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#21#,16#21#,16#4#,16#4#,16#4#,16#4#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#21#,16#21#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#21#,16#21#,16#0#,16#0#),
(16#20#,16#20#,16#4#,16#4#,16#0#,16#0#,16#24#,16#24#,16#56#,16#56#,16#77#,16#77#,16#56#,16#56#,16#76#,16#76#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#4#,16#4#,16#0#,16#1#,16#20#,16#20#),
(16#20#,16#20#,16#4#,16#4#,16#0#,16#0#,16#24#,16#24#,16#56#,16#56#,16#77#,16#77#,16#56#,16#56#,16#76#,16#76#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#5#,16#4#,16#0#,16#0#,16#20#,16#20#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#1#,16#1#,16#21#,16#21#,16#0#,16#0#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#76#,16#76#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#1#,16#1#,16#21#,16#21#,16#0#,16#0#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#76#,16#76#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#21#,16#21#,16#24#,16#24#,16#76#,16#76#,16#0#,16#20#,16#76#,16#76#,16#77#,16#77#,16#56#,16#56#,16#76#,16#76#,16#76#,16#76#,16#20#,16#20#,16#0#,16#1#,16#21#,16#21#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#21#,16#21#,16#24#,16#24#,16#76#,16#76#,16#0#,16#0#,16#76#,16#76#,16#77#,16#77#,16#56#,16#56#,16#76#,16#76#,16#76#,16#76#,16#20#,16#20#,16#0#,16#0#,16#21#,16#21#,16#0#,16#0#,16#0#,16#0#),
(16#4#,16#4#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#0#,16#0#,16#4#,16#1#,16#0#,16#0#,16#0#,16#0#,16#4#,16#4#),
(16#4#,16#4#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#4#,16#4#),
(16#0#,16#0#,16#24#,16#24#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#77#,16#77#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#24#,16#24#,16#20#,16#20#,16#1#,16#1#),
(16#0#,16#0#,16#24#,16#24#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#77#,16#77#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#24#,16#24#,16#20#,16#20#,16#0#,16#1#),
(16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#20#,16#20#,16#0#,16#1#,16#0#,16#0#,16#4#,16#0#,16#0#,16#0#,16#1#,16#1#),
(16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#1#,16#1#),
(16#20#,16#20#,16#4#,16#4#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#77#,16#77#,16#4#,16#4#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#21#,16#21#),
(16#20#,16#20#,16#4#,16#4#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#77#,16#77#,16#4#,16#4#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#21#),
(16#0#,16#1#,16#20#,16#20#,16#0#,16#0#,16#20#,16#20#,16#56#,16#56#,16#76#,16#76#,16#21#,16#1#,16#76#,16#76#,16#76#,16#76#,16#4#,16#4#,16#20#,16#20#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#20#,16#20#,16#56#,16#56#,16#76#,16#76#,16#1#,16#1#,16#76#,16#76#,16#76#,16#76#,16#4#,16#4#,16#20#,16#20#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#1#,16#0#,16#76#,16#76#,16#4#,16#4#,16#76#,16#76#,16#56#,16#56#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#76#,16#76#,16#4#,16#4#,16#76#,16#76#,16#56#,16#56#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#),
(16#4#,16#0#,16#20#,16#20#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#20#,16#20#,16#76#,16#76#,16#77#,16#77#,16#77#,16#77#,16#0#,16#0#,16#77#,16#76#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#0#,16#0#),
(16#4#,16#4#,16#20#,16#20#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#20#,16#20#,16#76#,16#76#,16#77#,16#77#,16#77#,16#77#,16#0#,16#0#,16#77#,16#76#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#0#,16#0#),
(16#1#,16#0#,16#0#,16#0#,16#0#,16#4#,16#20#,16#20#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#4#,16#20#,16#20#),
(16#0#,16#0#,16#0#,16#0#,16#4#,16#4#,16#20#,16#20#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#76#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#21#,16#21#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#1#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#21#,16#21#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#1#,16#1#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#4#,16#4#,16#0#,16#0#,16#1#,16#1#,16#0#,16#0#,16#0#,16#0#,16#20#,16#20#,16#0#,16#0#,16#1#,16#0#,16#20#,16#20#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#));