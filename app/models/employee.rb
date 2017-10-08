class Employee
  attr_accessor :id, :first_name, :last_name, :email, :birthday
  def initialize(options_hash)
    @id =options_hash["id"]
    @first_name = options_hash["first_name"]
    @last_name = options_hash["last_name"]
    @email = options_hash["email"]
    @birthday = options_hash["birthday"] ? Date.parse(options_hash["birthday"]) : "N/A"
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  
  def friendly_birthday
    if birthday == "N/A"
      "N/A"
    else
      birthday.strftime('%b %d, %Y')
    end
  end

  def self.find(employee_id)
    Employee.new(Unirest.get("#{ENV['HOST_NAME']}/api/v2/employees/#{params[:id]}.json").body)
  end
end