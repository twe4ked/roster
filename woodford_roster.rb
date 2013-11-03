NUMBER_OF_VOLUNTEERS = 11 # or 12

class Roster
  def initialize
    @days = []
  end

  def run!
    counter = 0

    (0..5).each do |index|
      day = Day.new
      @days << day

      while counter < 10_000; counter += 1
        break if check_2(day) && check_3(day) && check_1
        day.shuffle!
      end

      puts "#{counter} tries for day #{index + 1}"

      raise 'check_1' unless check_1
      raise 'check_2' unless check_2(day)
      raise 'check_3' unless check_3(day)
    end

    @days.each_with_index do |day, index|
      puts "Day #{index + 1}"
      puts day.info
      puts
    end
  end

  # 1. nobody has more than 3 morning shifts or night shifts
  #
  # Returns:
  #
  # true  - if the check passes
  # false - if the check fails
  def check_1
    people_in_morning_shifts = @days.map(&:morning)
    people_in_night_shifts = @days.map(&:night)

    no_more_than_3(people_in_morning_shifts) &&
    no_more_than_3(people_in_night_shifts)
  end

  def no_more_than_3(people)
    !people.flatten.group_by { |person| person }.values.detect { |group| group.size > 3 }
  end

  # 2. nobody works 2 morning shifts in a row
  #
  # Returns:
  #
  # true  - if the check passes
  # false - if the check fails
  def check_2(day)
    previous_morning = previous(:morning, day)
    (day.morning & previous_morning).empty?
  end

  # 3. nobody who works a night shift works a following morning shift
  #
  # Returns:
  #
  # true  - if the check passes
  # false - if the check fails
  def check_3(day)
    previous_night = previous(:night, day)
    (day.morning & previous_night).empty?
  end

  def previous(shift, day)
    index = @days.index(day)

    if (index - 1) < 0
      []
    else
      @days[index - 1].send(shift)
    end
  end
end

class Day
  def initialize
    @people = (1..NUMBER_OF_VOLUNTEERS).to_a.shuffle
  end

  def morning
    @people[0..3]
  end

  def afternoon
    @people[4..7]
  end

  def night
    @people[8..-1]
  end

  def shuffle!
    @people.shuffle!
  end

  def info
    <<-EOF.gsub(/^\s*/, '')
      Morning: #{self.morning.inspect}
      Afternoon: #{self.afternoon.inspect}
      Night: #{self.night.inspect}
    EOF
  end
end

Roster.new.run!
