maintainer       "Scott M. Likens"
maintainer_email "scott at likens dot us"
license          "Apache 2.0"
description      "Installs/Configures diamond"

version          "0.1.3"

%w{python git build-essential}.each do |p|
  depends p
end
