## ¡Bienvenido!

Este repositorio público está dedicado al desarrolo de códigos de cálculo numérico y visualización vía web de un Diagrama de Riesgo de covid19 diario. Está basado exclusivamente en datos públicos del número de casos testeados positivos diariamente. Se puede sin embargo complementar con datos no públicos diarios para estimar, cuantitativamente, el grado de riesgo de una población concreta. 

El algoritmo está descripto en [la descripción técnica](https://droyktton.github.io/loscoihues/DiagramasRiesgoRNyBRC.pdf).
Se trata básicamente de un predictor de corto término para el posible número de casos positivos en los siguientes días, basándose en la información histórica desde 14 días (no casualmente el tiempo medio esperado de recuperacíón de un infectado) atrás, hasta el de hoy. Cuando se compara este número con la capacidad sanitaria de la población referida, uno puede tener una idea cuantitativa de cuan cerca estamos de saturar esta capacidad, y por lo tanto de perder el control de la epidemia.

Es importante aclarar que la información es puramente estadística y los índices tienen asociado un error. Este error depende de muchísimos factores, del tamaño de la población, de la heterogeneidad de la red de contagios, de obtención y carga de datos, de la ocurrencia de eventos inesperados, y hasta de posibles mutaciones del virus. También es importante aclarar que es un indicador global, una simplificación de la verdadera compleja propagación de la epidemia, que es espacialmente heterogénea y temporalmente fluctuante. Pero es una simplificación que tiene sus ventajas, ya que permite capturar y racionalizar algunas de sus características generales.

El indicador, que ha sido usado en reportes oficiales en distintos países de Europa y Brasil, debería ser usado junto a otros indicadores para la toma de decisiones.

### Crecimiento Exponencial: Tiempo de Duplicación

La dinámica de la epidemia, en el régimen actual en Argentina, está básicamente controlada por la tasa de contagio, ya que la fracción de la población susceptible (es decir la que no está ni infectada ni inmunizada y puede contraer la enfermedad) es muy cercana al 100% (aunque para asegurarlo habría quizás que hacer por ejemplo testeos masivos aleatorios). Es decir, estamos probablemente muy lejos de lograr la denominada "inmunidad de rebaño". Por lo tanto, el crecimiento de la epidemia es, al menos en un intervalo reducido de tiempo, exponencial. 

En el contexto del simplístico pero paradigmático modelo SIR, esto quiere decir que (estrictamente en una población grande, homogénea y muy mezclada) que la fracción I de susceptibles está descripta pro la ecuación diferencial

dI/dt = beta I S - gamma I

donde "beta" es la frecuencia de contagio y "gamma" la frecuencia de recuperación. Si la fracción susceptible es S~1 entonces

I(t+dt) = I(t) exp[(beta-gamma) dt] = I(t) exp[gamma (R0-1) dt] = I(t) 2^{dt/tau} 

donde R0 (=beta/gamma en el contexto del modelo SIR) es el número de reproduccion básico, y tau el tiempo de duplicación. 
Por lo tanto 

tau = log(2) / gamma(R0-1)

Es decir, que si R0>1 el tiempo de duplicación es positivo, igual a log(2)/(R0-1) veces el tiempo de recuperación 1/gamma. 
Conociendo la evolución de I(t) uno también podría calcular tau de la siguiente manera,

tau = log(2)/[dlog(I(t))/dt]

Como no tenemos acceso al verdadero numero de infectados I(t), vamos a suponer que es proporcional al número de casos reportados acumulados A(t).

Luego, si discretizamos en días, si hoy es el día "t", y el número de casos testeados positico hace "dt" días fue N(t-dt), tenemos que el número de casos positivos esperables hoy es 

A(t)~ A(t-dt) 2^{dt/tau}, 

En tau días el número de casos positivos debería duplicarse si tau se mantuviera constante y positivo (un tau negativo significa que el número está decreciendo, mientras que tau=infinito podría indicar un crecimiento más lento que exponencial, por ejemplo lineal, o bien que el número de casos diarios es aproximadamente constante). 

Sin embargo, en la práctica tau no es constante y el modelo SIR, aunque captura lo básico, está lejos de describir la realidad. En particular, el tiempo de duplicación empírico fluctúa, y por diversas razones. Algunas son inherentes a la estocasticidad y memoria de la dinámica epidémica, otras a las fluctuaciones en el número de testeos y de carga de datos, y otras a las medidas de control y el grado de acatamiento de la sociedad. Su evaluación está entonces dificultada por fuertes e imprevistas fluctuaciones diarias, que son tanto más fuertes cuanto más pequeña sea la muestra poblacional. Esta variabilidad de N(t) es aún más compleja cuando la población considerada es muy heterogénea, ya que se suman fluctuaciones de distinta naturaleza.

Debido a las fluctuaciones, para obtener una estimación razonable de tau es más conveniente trabajar no con los fluctuantes datos diarios sino con los datos en un dado intervalo de tiempo razonable, por ejemplo de 7 días. Tenemos entonces varias alternativas para estimar tau. Todas estas deberían concidir en orden de magnitud si consideraramos cuidadosamente el error, sistemático y aleatorio, de cada método. 

#### Regresión lineal
El crecimiento exponencial con tiempo de duplicación tau en intervalo dt es equivalente a escribir

log A(t) ~ log A(t-dt) + {dt/tau} log(2), 

de modo que, en dt=7 días por ejemplo, un ajuste lineal por cuadrados mínimos de los arreglos de datos

Y={log N(t-3),log N(t-2),log N(t),log N(t+1),log N(t+2),log N(t+3)}
X={0,1,2,3,4,5,6,7} 

al modelo con parámetros ajustables p1 y p2

Y= p2 + p1 * X 

dá tau=log(2)/p1 como parámetro de ajuste. La regresión lineal da tanto el error de tau, como la desviación estandard del modelo a los datos, y la bondad del fit. Ambas cantidades deberían ser tenidas en cuenta junto con el reporte del tau óptimo. 

Esta forma de estimar tau está centrada en el tiempo t, por lo que se debe prestar atención a los efectos de borde, cerca del día de la fecha, ya que no hay casos para adelante en el tiempo. Una alternativa es trabajar con una ventana atrasada {log N(t-7),log N(t-6),....,log N(t)}, dando mas peso a los dias pasados. 

#### Tasa reproductiva  

Si el número de casos diarios es N(t), la cantidad

rho(t) = [N(t+1)+N(t)+N(t-1)]/[N(t-6)+N(t-5)+N(t-4)] 

es una tasa reproductiva empirica, que tiene en cuenta que los casos acumulados en pocos días (tres en este caso) son debidos a los casos acumulados en tres días anteriores, en este caso 5 días antes. Es decir, contempla el delay entre la detección de los casos primarios y la de los secundarios.

Esta tasa reproductiva empirica es sin embargo aún muy ruidosa. Por ello a su vez la promediamos en una ventana de 7 días

rho_7(t) = [rho(t-3)+rho(t-2)+rho(t-1)+rho(t)+rho(t+1)+rho(t+2)+rho(t+3)]/7

Esta es la coordenada Y de nuestros diagramas de riesgo, a la que llamamos Tasa de Reproducción, o Número de Reproducción Efectivo.

#### Tasa de Ataque  

Si conociéramos la cantidad de casos positivos hoy, podríamos utilizar rho_7 para estimar la cantidad de casos positivos mañana. Como no conocemos esta cantidad, la estimamos como el número de casos positivos acumulados los ultimos 14 días, los cuales pueden por tanto considerarse "casos activos". Llamamos a esta cantidad IA14, 

IA14(t) = [N(t-14)+N(t-13)+N(t-12)+...+N(t-3)+N(t-2)+N(t-1)+N(t)] * 100000/Npoblación

donde el último factor se introduce para medir IA14 de forma intensiva, por cada 100000 habitantes (la elección 100000 es arbitraria y se elije sólo para fijar unidades convenientes). 

#### Predicción a corto término  

Si hay rho_7 nuevos positivos por cada positivo hoy, entonces mañana podemos esperar una cantidad EPG de casos positivos por cada 100000 habitantes definida como

EPG(t)=rho_7(t) x IA14(t) 

#### Cuantificación del Riesgo 

Es importante por que el sistema sanitario este preparado para controlar los EPG nuevos casos. 
Por un lado, es deseable que la capacidad de testeo diario por cada 100000 habitantes, TDL, alcance para testear a los nuevos casos que darán positivo, es decir que aproximadamente se de la condición

EPG < TDL

por otro lado, si de esa cantidad EPG hay una fracción fxEPG que contraerá síntomas graves, y necesitará de cuidados intensivos, es deseable que la cantidad C de UTIs y UCIs por cada 100000 habitantes, cumpla la condición 

f x EPG < C

Así, el índice EPG se convierte en indicador de riego, ya que no debería sobrepasar los siguientes límites

Límite de capacidad de testeo = TDL
Límite de capacidad hospitalaria = C/f

La interpretación sugerida es que las medidas de control se realicen, atendiendo a la cercanía del EPG a estos límites, en la trayectoria definida por las coordenadas diarias rho_7 y AI14 de la epidemia.  

#### Dinámica controlada por brotes

La trayectoria de rho_7 y AI14 suele ser bastante irregular y cíclica cuando la dinámica esta dominada por brotes, ya que si rho7 aumenta, esto inducirá un aumento de AI14, con lo cual un desplazamiento vertical en el diagrama termina torciéndose hacia la derecha. Si se controla el brote tomando medidas de control, rho7 disminuye, con lo cual IA14 deja de crecer. Eventualmente, si la tasa de recuperación (14 días) es más alta que la reproductiva el número de positivos activos decrecerá, aproximadamente cerrando el ciclo. 

Cuando el número de brotes es muy grande, el efecto descripto se vuelve más borroso. Por ello el diagrama correspondiente a poblaciones mas grandes siempre luce mas regular y menos cíclico, al combinarse distintos tiempos de inicio de los brotes independientes.

#### Aplicabilidad

Las predicciones más precisas del Diagrama de Riesgo se esperan para el caso de una población grande y homogénea. Como son dos requisitos dificiles de encontrar en general, en la práctica el mejor será un compromiso entre ambas. Es decir una población de tamaño intermedio. Y por último, este es uno de tantos indicadores, captura solo un minúsculo aspecto de la epidemia, y debería usars en combinación con otros análisis estadsticos.







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
