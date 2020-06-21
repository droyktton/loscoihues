## ¡Bienvenido!

Este repositorio público está dedicado al desarrolo de códigos de cálculo numérico y visualización vía web de un indicador de riesgo de covid19 diario. Está basado exclusivamente en datos públicos. Se puede sin embargo complementar con datos no públicos diarios para estimar el grado de riesgo de una población concreta. En particular, es fundamental conocer la capacidad sanitaria, de testeo y hospitalaria.  

El algoritmo está descripto en https://droyktton.github.io/loscoihues/DiagramasRiesgoRNyBRC.pdf .
Se trata de estimar un predictor de corto término del posible número de casos positivos en los siguientes días, basandose en la información histórica desde 14 días (no casualmente el tiempo medio esperado de recuperacíón de un infectado) atrás, hasta el de hoy. Cuando se compara este número con la capacidad sanitaria de la población referida, uno puede tener una idea de cuan cerca estamos de saturar esta capacidad, y por lo tanto de perder el control de la epidemia.

Es importante aclarar que la información es puramente estadística y los índices tienen asociado un error. Este error depende del tamaño de la población y de la heterogeneidad de la red de contagios, y quizás también de otros factores como la carga de datos. También es importante aclarar que es un indicador global, una simplificación de la espacialmente heterogénea y temporalmente fluctuante verdadera propagación de la epidemia. Pero es una simplificación que tiene sus ventajas, ya que permite capturar y racionalizar algunas de sus características generales.

El indicador, que ha sido usado en reportes oficiales en distintos países de Europa y Brasil, debería ser usado junto a otros indicadores para la toma de decisiones.





## Welcome to GitHub Pages

You can use the [editor on GitHub](https://github.com/droyktton/loscoihues/edit/master/README.md) to maintain and preview the content for your website in Markdown files.

Whenever you commit to this repository, GitHub Pages will run [Jekyll](https://jekyllrb.com/) to rebuild the pages in your site, from the content in your Markdown files.

### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/droyktton/loscoihues/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://help.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
