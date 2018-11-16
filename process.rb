class PROCESS
  require_relative 'ITERATOR'
  $blood_compatibility = {"A" => ["A", "C"], # A+
        "Z" => [ "A", "Z", "C", "X" ], # A-
        "B" => ["B", "C"], # B+
        "Y" => ["B", "Y", "C", "X"], # B-
        "C" => ["C"], # AB+
        "X" => ["C", "X"], # AB-
        "O" => ["A", "B", "C", "O"], # O+
        "W" => ["A", "Z", "B", "Y", "C", "X", "O", "W"]} # O-
  $ga, $gz, $gb , $gy, $gc, $gx, $go, $gw = [], [], [], [], [], [], [], [] # Ini arrays same group
  $group_type = {} # Ini hash for divided patients by blood types
  #$register = 0

  def read
    $t1 = Time.now  # Init procedure timestamp
    person = []
    IO.foreach("data_100.txt") do |line| # Get all patients from file iterate each line
      line.chomp!  # Remove trailing whitespace.
      person.push(line.split(":"))  # Saving data split :
    end
    group(person) # Get blood type
  end

  def matches(b)
     $blood_compatibility[b] # Get compatibility from each blood type
  end

  def group(person)
    person = List.new(person)
    person.iterator do |p|  # Patient iterator
      type = p.last
      case type # Divide patients in groups type
        when  "A"
          $ga.push(p)
        when  "Z"
          $gz.push(p)
        when  "B"
          $gb.push(p)
        when  "Y"
          $gy.push(p)
        when  "C"
          $gc.push(p)
        when  "X"
          $gx.push(p)
        when  "O"
          $go.push(p)
        when  "W"
          $gw.push(p)
        else
          break
      end
    end
    # Save divided patients in a Hash with key-> Blood type
    $group_type["A"] = $ga
    $group_type["Z"] = $gz
    $group_type["B"] = $gb
    $group_type["Y"] = $gy
    $group_type["C"] = $gc
    $group_type["X"] = $gx
    $group_type["O"] = $go
    $group_type["W"] = $gw

    receivers(person)
  end

  def receivers(person)
    receivers_list = {}
    person.iterator do |p| # Patients iteration
      name = []
      match = matches(p.last) # Search blood matches
      match.each do |m|
        $group_type[m].each do |gp| # Blood type iterator of each patient
          name.push(gp.first)
        end
      end
      receivers_list[p.first] = name # Save Hash with: (Patient donor)->[receivers]
    end

    combinations(receivers_list)
  end

  def combinations(receivers_list) # Receivers combinations of each blood donor
    receivers_list.each do |key, attrs|
      puts "\nPatient #{key} can donate to:"
      comb = [[key],attrs]
      puts "\n #{combinations_iterator(comb).join(' ')}"
    end
  end

  def combinations_iterator(a)
    first = a.first # Get first receiver to start
    if a.length==1 # If only one receiver
      first
    else
      rest = combinations_iterator(a[1..-1]) # Receivers iteration
      first.map{rest.map{ |y| "#{y}," } }.flatten # Map generator donor with receivers
    end
  end

  def time_diff_milli(start, finish) # Elapsed time
    puts "\nElapsed time: #{(finish - start) * 1000.0} ms"
  end
end