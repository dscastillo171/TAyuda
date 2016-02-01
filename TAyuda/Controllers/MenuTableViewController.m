//
//  MenuTableViewController.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/25/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "MenuTableViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:125/255.0 alpha:1.0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        // Inicio
        SWRevealViewController *revealController = self.revealViewController;
        [revealController rightRevealToggleAnimated:YES];
        
        UINavigationController *navigationController = (UINavigationController *)revealController.frontViewController;
        NSArray *viewControllers = [navigationController viewControllers];
        if([viewControllers count] > 0){
            [navigationController setViewControllers:@[[viewControllers firstObject]] animated:YES];
        }
    } else if(indexPath.row == 1){
        // Términos y Condiciones
        SWRevealViewController *revealController = self.revealViewController;
        [revealController rightRevealToggleAnimated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Términos y condiciones."
                                                        message:
                              @"Estos Términos de uso rigen la utilización que haces de la aplicación wabi cuya administración se encuentra radicada en la ciudad de Bogotá cuya gestión de contenidos es operada por profesionales  bajo la coordinación de Iregui Cahiz SAS\n\nEstos Términos de uso incluyen la política de privacidad respectiva:\n\n1. Cargos de internet o plan de datos: al descargar wabi haciendo uso de planes de datos suministrados por operadores telefónicos, el usuario de la aplicación será el único  responsable del pago de todos los gastos en los que incurras como resultado de descargar y usar wabi.\n\n2. Wabi, puede vincular a través de links  servicios o sitios de terceros que no son de propiedad o están controladas por la Aplicación, en tal sentido wabi no es responsable ni patrocina, respalda, auspicia los productos o servicios ofrecidos por dichos terceros. Con base en lo anterior cuando el usuario hace clic en alguno de esos links será transportado a la página del proveedor de dichos servicios, quienes serán directamente responsable de los aspectos legales de los mismos y en consecuencia wabi no es responsable por ninguna transacción, compra, contratación, ofrecimiento, publicidad, contenido, política de privacidad o practica de terceros a los que se pueda acceder a través de la aplicación.\n\n3. Ingeniería inversa: el usuario que descargue y utilice wabi desde ya se obliga a:\n\na. No realizar ningún tipo de ingeniería inversa sobre la aplicación incluyendo desensamblar, descompilar o intentar de cualquier modo obtener acceso al código fuente de la aplicación.\n\nb. A no reproducir copiar o utilizar ninguno de los contenidos a los que pueda acceder o visualizar a través de la aplicación.\n\nc. A no copiar ninguna parte de la aplicación o hacer uso comercial de ella o alguna de sus partes.\n\nd. Abstenerse de utilizar lenguaje obseno , inapropiado, vulgar, irrespetuoso o hacer afirmaciones que puedan constituir injuria o calumnia al momento de formular cualquiera de las consultas que envíe haciendo uso de la aplicación. Wabi se reserva discrecionalmente el derecho sin necesidad de esbozar las razones de responder las consultas que sean realizadas haciendo uso de la aplicación.\n\n4. Manejo y reserva de la información personal: wabi respetando estrictamente las disposiciones de la ley 1581 del 2012 hará un manejo responsable y reservado de la información que recopile de cualquier usuario de la aplicación. Wabi en ningún caso recopilara ningún dato distinto al correo electrónico de las personas que envíen consultas a la aplicación.\n\n5. Desde ya el usuario por el solo hecho de descargar la aplicación wabi y enviar consultas haciendo uso de su plataforma autoriza que se les sea enviado a su correo electrónico ofertas comerciales de productos o servicios relativos a su objeto de su consulta y/o a cualquier otra.\n\n6. wabi se reserva el derecho y así lo acepta el usuario que descargue la aplicación, modificar estos términos y condiciones de uso sin avisar en cualquier momento. si  el usuario continúa usando la aplicación wabi  una vez realizada cualquier modificación en estos términos y condiciones, ese uso continuado constituirá la aceptación de tal modificación. si el usuario  no acepta estos términos y condiciones de uso, ni acepta quedar sujeto a ellos, no debe descargar o usar  la aplicación wabi. wabi no ofrece ninguna garantía y rechaza toda responsabilidad por la existencia, oportunidad, seguridad, fiabilidad y calidad de cualquier, información que sea suministrada a través de la plataforma  o de otros productos, servicios e información obtenidos a través de la aplicación.\n\n7. No tenemos responsabilidad alguna por la eliminación de, o la incapacidad de almacenar o transmitir, cualquier contenido u otra información mantenida o transmitida por la aplicación.\n\n8. No somos responsables de la precisión o la fiabilidad de cualquier información o consejo transmitidos a través de la aplicación wabi, podemos en cualquier momento, limitar o interrumpir tu uso de las aplicaciones de wabi.\n\n9. El usuario Reconoce que poseemos todos los derechos, la propiedad y los intereses en relación con la Aplicación    es la marca comercial o la marca registrada de wabi. No alterarás, destruirás, ocultarás ni suprimirás en forma algún ningún aviso de derechos de autor o de propiedad contenido en la Aplicación.\n\n10. Hasta el máximo que permiten los derechos legales del cliente (conforme sean aplicables), estos Términos y condiciones de uso se rigen por las leyes de Colombia, excluidos sus conflictos con las disposiciones legales. Otorga su consentimiento a la jurisdicción de los tribunales de Colombia.\n\n-\n\nAl descargar o utilizar la aplicación, aceptará automáticamente estos términos. Asegúrese de leerlos atentamente antes de utilizar la aplicación. Le ofrecemos esta aplicación para su uso personal sin ningún costo.\n\nLa aplicación y todas las marcas comerciales, los derechos de autor, los derechos sobre bases de datos y demás derechos de propiedad intelectual relacionados continuarán siendo propiedad de wabi.\n\nwabi pretende garantizar que la aplicación sea siempre lo más útil y eficiente posible. Por este motivo, nos reservamos el derecho de efectuar cambios en la aplicación en cualquier momento y por cualquier motivo.\n\nRecuerde que, si utiliza la aplicación fuera de una zona con conexión Wi-Fi, se aplicarán los términos del contrato con su proveedor de servicios de red móvil. Por consiguiente, el proveedor de servicios móviles podrá aplicar cargos por los datos consumidos durante la conexión al acceder a la aplicación, así como otros cargos de terceros. Si utiliza la aplicación, acepta la responsabilidad en relación con dichos cargos, incluidos los cargos por los datos de roaming si utiliza la aplicación fuera del territorio de origen (su región o país) sin desactivar el roaming de datos.\n\nEs posible que en algún momento debamos actualizar la aplicación. En estos momentos, la aplicación está disponible para iOS y Android. Existe la posibilidad de que se modifiquen los requisitos necesarios para ambos sistemas (y para cualquier otro sistema adicional para el que se ofrezca la aplicación en el futuro), por lo que deberá descargar las actualizaciones si desea continuar utilizando la aplicación. wabi no garantiza que vaya a ofrecer siempre las actualizaciones que usted necesite o que sean compatibles con la versión de iOS/Android instalada en su dispositivo. No obstante, usted garantiza que aceptará todas las actualizaciones de la aplicación cuando se le ofrezcan. También es posible que deje de ofrecerse la aplicación y se interrumpa su uso en cualquier momento sin previo aviso. A menos que se indique lo contrario, tras la terminación: (a) cesarán los derechos y las licencias concedidos mediante los presentes términos; (b) deberá suspender el uso de la aplicación y, si fuera necesario, eliminarla de su dispositivo.\n\n-\n\nReclamos por violación de derechos en la Aplicación Móvil\n\nEn caso de que un visitante crea que sus derechos de propiedad intelectual o marcas registradas puedan estar siendo violados por materiales publicados o almacenados en esta Aplicación Móvil, deberá completar la “Notificación de Violación de Derechos” del enlace y enviar un correo electrónico a nuestro e-mail: tuconsulta@informativolegal.com  con una copia de confirmación enviada a:\n\nIregui Cahiz SAS\nAv calle 100 # 60-04 oficina 306\nEdificio Master Center\nBogota-Colombia\n\nDicha Notificación debe brindar la información requerida en cumplimiento de las cláusulas aplicables de la Ley de derechos de autor."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else if(indexPath.row == 2){
        SWRevealViewController *revealController = self.revealViewController;
        [revealController rightRevealToggleAnimated:YES];
        
        UINavigationController *navigationController = (UINavigationController *)revealController.frontViewController;
        NSArray *viewControllers = [navigationController viewControllers];
        if([viewControllers count] > 0){
            UIViewController *consultaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConsultaViewController"];
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Atrás" style:UIBarButtonItemStylePlain target:nil action:nil];
            [[[viewControllers firstObject] navigationItem] setBackBarButtonItem:newBackButton];
            [navigationController setViewControllers:@[[viewControllers firstObject], consultaViewController] animated:YES];
            
        }
    }
}

@end
