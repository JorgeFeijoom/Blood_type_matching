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
  $last_patient = ""
  $register = 0

  def read
    $t1 = Time.now  # Init procedure timestamp
    person = []
    IO.foreach("data_500.txt") do |line| # Get all patients from file iterate each line
      line.chomp!  # Remove trailing whitespace.
      person.push(line.split(":"))  # Saving data split :
    end
    get_combinations(person) # Get blood type
  end

  # Checks blood compatibility between two persons
  def check_compatibility(patient1_blood, patient2_blood)
      $blood_compatibility[patient1_blood].each do |blood|
        if blood == patient2_blood
            return true
        end
      end
  end

# Gets the list of all compatible persons
  def get_compatibility(combination)
      patient1 = combination[0]
      patient2 = combination[1]
      p1_blood = patient1[(patient1).size-1]
      p2_blood = patient2[(patient2).size-1]
      $last_patient
      if check_compatibility(p1_blood, p2_blood)
        if $last_patient != patient1
          $last_patient = patient1
          print"\n\nPatient #{patient1} can donate to:\n\n"
        end
        print "#{patient2} \n"
      end
  end


# Gets all combinations without repetition of the given persons
  def get_combinations(persons)
      persons.combination(2).each do |comb|
        get_compatibility(comb)
      end
  end

  def time_diff_milli(start, finish) # Elapsed time
    puts "\nElapsed time: #{(finish - start) * 1000.0} ms"
  end
end