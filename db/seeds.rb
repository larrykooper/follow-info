FollowInfoUser.create(email: "larry.kooper@gmail.com", encrypted_password: "$2a$11$dQAZcHJlw1Nrkb81P5vkO.A1tg7blvrhVi1SC.mOEvxlWm3v3NdNS")

natpol = Tag.create(name: "national-politics")
music = Tag.create(name: "music")
media = Tag.create(name: "media")

cnn = User.create(name: "cnn")
brooke = User.create(name: "brooke")
tracey = User.create(name: "Tracey")

Tagging.create(user_id: cnn.id, tag_id: media.id)
Tagging.create(user_id: tracey.id, tag_id: music.id)
