# 'Interface' for all implementing tools.
# Not very Ruby-y for this concept, just
# a small reminder t
class ToolBase

  # Public declarations
  public

    # Launches the tool into action
    def launch
      # To be overriden in subclass,
      # not implemented here.
      raise NotImplementedError
    end

    # Reports progress, usually hooked
    # to a progressbar or notification area.
    def report_progress(p_args)
      # To be overriden in subclass,
      # not implemented here.
      raise NotImplementedError
    end

    # Reports 'job done'
    def report_done
      # To be overriden in subclass,
      # not implemented here.
      raise NotImplementedError
    end

end # class ToolBase