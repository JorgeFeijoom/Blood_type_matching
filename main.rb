class MAIN
  require_relative 'PROCESS'

  c = PROCESS.new #Run process
  c.read

  $t2 = Time.now

  ARGV.each do|a| # -t argument for elapsed time
    if a == "-t"
      $msecs = c.time_diff_milli $t1, $t2
    end
  end

end