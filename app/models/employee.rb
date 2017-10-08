class Employee
  HEADERS = {
            "Accept" => "application/json",
            "X-User-Email" => "joe@gmail.com",
            "Autherization" => "Token token=#{ ENV['API_KEY'] }
            }

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
    Employee.new(Unirest.get(
                            "#{ENV['HOST_NAME']}/api/v2/employees/#{ employee_id }.json",
                            headers: {
                                      "X-User-Email" => "joe@gmail.com",
                                      "Autherization" => "Token token=infonomnom"
                                     }
                            ).body)
  end

  def self.all
    employee_collection = []
    employee_hashes = Unirest.get(
                                "#{ ENV['HOST_NAME'] }/api/v2/employees.json"},
                                headers: {
                                          "X-User-Email" => "joe@gmail.com",
                                          "Autherization" => "Token token=infonomnom"
                                         }

                                  ).body
                                
    employee_hashes.each do |employee_hash|
      employee_collection << Employee.new(employee_hash)
    end
    employee_collection
  end

  def destroy
        response = Unirest.delete(
                                  "#{ ENV['HOST_NAME'] }/api/v2/employees/#{params[:id]}",
                                  headers: { "Accept" => "application/json"}
                                  )
    
  end

  def self.create(employee_params)
    response = Unirest.post(
                           
                           "#{ ENV['HOST_NAME'] }/api/v2/employees",
                           headers: { "Accept" => "application/json" }, 
                           parameters: employee_params
                           ).body

    Employee.new(response)
    
  end

  def update(employee_params)
    response = Unirest.patch(
                              "#{ ENV['HOST_NAME'] }/api/v2/employees/#{ id }",
                              headers: { "Accept" => "application/json" },
                              parameters: employee_params
                              ).body
    Employee.new(response)
    
  end

end