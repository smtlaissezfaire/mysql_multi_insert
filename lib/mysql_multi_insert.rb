module MysqlMultiInsert
  def multi_insert(record_array, options={})
    MultiInsertion.run(self, record_array, options)
  end

  class MultiInsertion
    def self.run(klass, array, options={})
      new(klass, array).run(options)
    end

    def initialize(klass, array)
      @klass = klass
      @array = array
    end

    def run(options={})
      if @array.any?
        if options[:skip_validations] == true || @array.all? { |record| record.valid? }
          insert_records(@array)
        end
      end
    end

  private

    def insert_records(array)
      str = "INSERT INTO #{table_name} "
      str << "(#{quoted_column_names(array.first)}) VALUES "
      
      length = array.length - 1
      
      array.each_with_index do |record, index|
        str << "(#{quoted_values(record)})"
        str << ", " unless index == length
      end
      
      connection.execute str
    end

    def quoted_column_names(record)
      r = record.send(:quoted_column_names)
      r.join(", ")
    end

    def quoted_values(record)
      quoted_attributes(record).values.join(", ")
    end

    def quoted_attributes(record)
      record.send :attributes_with_quotes, false, false
    end

    def table_name
      @klass.table_name
    end

    def execute(str)
      connection.execute(str)
    end

    def connection
      @klass.connection
    end
  end
end
