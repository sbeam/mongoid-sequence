require "mongoid-sequence/version"
require "active_support/concern"

module Mongoid
  module Sequence
    extend ActiveSupport::Concern

    included do
      set_callback :validate, :before, :set_sequence, :unless => :persisted?
    end

    module ClassMethods
      attr_accessor :sequence_fields

      def sequence(field, options = {})
        self.sequence_fields ||= []
        self.sequence_fields << [field, options]
      end
    end

    def set_sequence
      database = self.class.collection.database
      sequences = database["__sequences"]
      self.class.sequence_fields.each do |field, options|
        offset = (options[:offset] || 0).to_i
        next_seq = sequences
          .find(id: "#{self.class.name.underscore}_#{field}")
          .find_one_and_update({
            :$inc => {
              "seq" => 1
            }},
            upsert: true,
            return_document: :after
        )

        self[field] = next_seq["seq"] + offset
      end if self.class.sequence_fields
    end
  end
end
