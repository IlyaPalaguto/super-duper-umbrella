module ManufacturerCompany
	def company
		self.manufacturer_company
	end

	def set_company(title)
		self.manufacturer_company = title
	end

	protected
	attr_accessor :manufacturer_company
end