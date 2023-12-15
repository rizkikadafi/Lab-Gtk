lab_gtk_sources = [
  'main.vala', 'application.vala', 'window.vala', 'data.vala', 'model.vala',
  'model/document.vala', 'model/content.vala', 'model/metadata.vala',
  'model/type.vala', 'model/any.vala', 'model/database.vala',
  'model/struct/node.vala', 'model/struct/nodes.vala',
  'utils/ioutil.vala', 'utils/util.vala', 'utils/error.vala'
]

cc = meson.get_compiler('c')
m_dep = cc.find_library('m', required : false)
posix_dep = meson.get_compiler('vala').find_library('posix')

lab_gtk_deps = [
  dependency('gtk4'),
  dependency('gee-0.8'),
  dependency('gio-2.0'),
  m_dep,
  posix_dep,
]

lab_gtk_sources += gnome.compile_resources('lab-gtk-resources',
  'lab-gtk.gresource.xml',
  c_name: 'lab_gtk'
)

executable('lab-gtk', lab_gtk_sources,
  dependencies: lab_gtk_deps,
       install: true,
)
