signal alienDirection : integer range 0 to 7 := 0;

process(reset, clk)
begin
  if reset = '1' then
    alienDirection <= 0;
    alienJump      <= 1;
  elsif rising_edge(clk) then
    -- alien direction
    if alienDirection >= 7 then
      alienDirection <= 0;
    else
      alienDirection <= alienDirection + 1;
    end if;
    -- alien jump
    if alienJump >= maxAlienJump then
      alienJump <= 1;
    else
      alienJump <= alienJump + 1;
    end if;
  end if;
end process;