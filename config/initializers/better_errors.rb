if defined? BetterErrors
  BetterErrors.editor = proc { |full_path, line|
    full_path = full_path.sub(Rails.root.to_s, '/Users/brenoperucchi/Google-Drive/03-Apps/appweb')
    "subl://open?url=file://#{full_path}&line=#{line}"
  }
end