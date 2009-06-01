module MysqlMultiInsert
  def multi_insert(record_array)
    MultiInsertion.run(self, record_array)
  end

  class MultiInsertion
    def self.run(klass, array)
      new(klass, array).run
    end

    def initialize(klass, array)
      @klass = klass
      @array = array
    end

    def run
      str = "INSERT INTO #{table_name} "
      str << "(#{quoted_column_names(@array.first)}) VALUES "

      length = @array.length - 1

      @array.each_with_index do |record, index|
        str << "(#{quoted_values(record)})"
        str << ", " unless index == length
      end

      connection.execute str
    end

  private

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
