class Skill
  include Comparable

  attr_reader :errors, :name, :id, :training_path_id

  def initialize(options)
    @errors = nil
    @name = options[:name]
    @description = (options[:description].nil? || options[:description].empty?) ? "" : options[:description]
    @training_path_id = options[:training_path].nil? ? nil : options[:training_path].id
    @id = options[:id] unless options[:id].nil?
  end

  def self.create(options)
    skills = Skill.new(options)
    skills.save!
    skills
  end

  def self.count
    Environment.database.execute("SELECT count(id) FROM skills")[0][0]
  end

  def self.last
    row = Environment.database.execute("SELECT * FROM skills ORDER BY id DESC LIMIT 1").last
    if row.nil?
      nil
    else
      values = { id: row[0], name: row[1], description: row[2], training_path_id: row[3] }
      Skill.new(values)
    end
  end

  def <=>(other)
    self.id <=> other.id
  end

  def save!
    if valid?
      Environment.database.execute("INSERT INTO skills(name, description, training_path_id) VALUES ('#{@name}', '#{@description}', '#{@training_path_id}')")
    end
  end

  def valid?
    validate
    @errors.nil?
  end

  private

  def validate
    if @name.empty?
      @errors = "name cannot be blank"
    elsif @training_path_id.nil?
      @errors = "training path cannot be blank"
    else
      @errors = nil
    end
  end
end
