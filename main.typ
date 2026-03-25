#set page(
  margin: 2cm,
  header: header,
  footer: footer,
)

// Header
#let header = context {
  grid(
    columns: (auto, 1fr),
    align: (left, right),
    [
      // Left: Image
      //image("logo.png", height: 1.5cm)
      adfa
    ],
    [
      // Right: Header text
      align(right)[
        *Document Title* \
        Author Name \
        Date
      ]
    ]
  )
  line(length: 100%)
}

// Footer
#let footer = context {
  align(right)[
    Page #counter(page).display() / #counter(page).final()
  ]
}

// Document content
= Section Title

Your content here.
