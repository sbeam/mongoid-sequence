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

      def sequence(field)
        self.sequence_fields ||= []
        self.sequence_fields << field
      end
    end

    def set_sequence
      database = self.class.collection.database
      sequences = database["__sequences"]
      self.class.sequence_fields.each do |field|
        sequence = sequences.find(_id: "#{self.class.name.underscore}_#{field}")
        next_sequence = sequence.modify(
          {"$inc" => {"seq" => 1}},
          new: true,
          upsert: true
        )

        self[field] = next_sequence["seq"]
      end if self.class.sequence_fields
    end
  end
end
