class READER
  $blood_compatibility = {"A" => ["A", "C"], # A+
        "Z" => [ "A", "Z", "C", "X" ], # A-
        "B" => ["B", "C"], # B+
        "Y" => ["B", "Y", "C", "X"], # B-
        "C" => ["C"], # AB+
        "X" => ["C", "X"], # AB-
        "O" => ["A", "B", "C", "O"], # O+
        "W" => ["A", "Z", "B", "Y", "C", "X", "O", "W"]} # O-
  $ga, $gz, $gb , $gy, $gc, $gx, $go, $gw = [], [], [], [], [], [], [], []
  $group_type = {}

  def read
    #person = Hash.new
    person = []
    IO.foreach("dataset.txt") do |line|
      # Remove trailing whitespace.
      line.chomp!
      #Saving data
      person.push(line.split(":"))
    end
    blood(person)
  end

  def blood(person)
    person_match = []
    person.each do |p|
       person_match.push(matches(p.last))
    end
    group(person)
  end

  def matches(b)
     $blood_compatibility[b]
  end

  def group(person)
    person.each do |p|
      type = p.last
      case type
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

    person.each do |p|
      name = []
      match = matches(p.last)

      match.each do |m|
        $group_type[m].each do |gp|
          name.push(gp)
        end
      end
      receivers_list[p.first] = name
    end

    combinations(receivers_list)
  end

  def combinations(receivers_list)
    hash_names = {}
    receivers_list.each do |donor,receivers|
      list_of_names = []
      receivers.each do |r|
        list_of_names.push(r)
        hash_names[donor] = list_of_names
      end
    end
    combinations_iteration(hash_names)
  end

  def combinations_iteration(hsh)
    #print hsh
    receivers_h = {}
    hsh.each do |key, attrs|
      receivers = []
      puts "Donor:  #{key} | Receivers:  #{attrs}."
      attrs.each do |p|
        receivers.push(p.first)
      end
      receivers_h[key] = receivers
    end
    receivers_h.each do |key, attrs|
      comb = [[key],attrs]
      puts "\n Donor: #{key} \n"
      puts variations(comb).join(' ')
      puts "\n"
    end

  end
  def variations(a)
    first = a.first
    if a.length==1 then
      first
    else
      rest = variations(a[1..-1])
      first.map{ |x| rest.map{ |y| "#{x}#{y}" } }.flatten
    end
  end
end

c = READER.new
c.read

